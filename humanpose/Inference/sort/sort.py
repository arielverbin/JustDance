"""
    SORT: A Simple, Online and Realtime Tracker
    Copyright (C) 2016-2020 Alex Bewley alex@bewley.ai

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""
from __future__ import print_function

import numpy as np
from filterpy.kalman import KalmanFilter
from scipy.optimize import linear_sum_assignment

np.random.seed(0)


def linear_assignment(cost_matrix):
    try:
        import lap
        _, x, y = lap.lapjv(cost_matrix, extend_cost=True)
        return np.array([[y[i], i] for i in x if i >= 0])
    except ImportError:
        x, y = linear_sum_assignment(cost_matrix)
        return np.array(list(zip(x, y)))


def iou_batch(bb_test, bb_gt):
    """
    From SORT: Computes IOU between two bboxes in the form [x1,y1,x2,y2]
    """
    bb_gt = np.expand_dims(bb_gt, 0)
    bb_test = np.expand_dims(bb_test, 1)

    xx1 = np.maximum(bb_test[..., 0], bb_gt[..., 0])
    yy1 = np.maximum(bb_test[..., 1], bb_gt[..., 1])
    xx2 = np.minimum(bb_test[..., 2], bb_gt[..., 2])
    yy2 = np.minimum(bb_test[..., 3], bb_gt[..., 3])
    w = np.maximum(0., xx2 - xx1)
    h = np.maximum(0., yy2 - yy1)
    wh = w * h
    o = wh / ((bb_test[..., 2] - bb_test[..., 0]) * (bb_test[..., 3] - bb_test[..., 1])
              + (bb_gt[..., 2] - bb_gt[..., 0]) * (bb_gt[..., 3] - bb_gt[..., 1]) - wh)
    return o


def convert_bbox_to_z(bbox):
    """
    Takes a bounding box in the form [x1,y1,x2,y2] and returns z in the form
      [x,y,s,r] where x,y is the centre of the box and s is the scale/area and r is
      the aspect ratio
    """
    w = bbox[2] - bbox[0]
    h = bbox[3] - bbox[1]
    x = bbox[0] + w / 2.
    y = bbox[1] + h / 2.
    s = w * h  # scale is just area
    r = w / float(h)
    return np.array([x, y, s, r]).reshape((4, 1))


def convert_x_to_bbox(x, score=None):
    """
    Takes a bounding box in the centre form [x,y,s,r] and returns it in the form
      [x1,y1,x2,y2] where x1,y1 is the top left and x2,y2 is the bottom right
    """
    w = np.sqrt(x[2] * x[3])
    h = x[2] / w
    if score is None:
        return np.array([x[0] - w / 2., x[1] - h / 2., x[0] + w / 2., x[1] + h / 2.]).reshape((1, 4))
    else:
        return np.array([x[0] - w / 2., x[1] - h / 2., x[0] + w / 2., x[1] + h / 2., score]).reshape((1, 5))


class KalmanBoxTracker(object):
    """
    This class represents the internal state of individual tracked objects observed as bbox.
    """
    count = 0

    def __init__(self, bbox, score):
        """
        Initialises a tracker using initial bounding box.
        """
        # define constant velocity model
        self.kf = KalmanFilter(dim_x=7, dim_z=4)
        self.kf.F = np.array([[1, 0, 0, 0, 1, 0, 0],
                              [0, 1, 0, 0, 0, 1, 0],
                              [0, 0, 1, 0, 0, 0, 1],
                              [0, 0, 0, 1, 0, 0, 0],
                              [0, 0, 0, 0, 1, 0, 0],
                              [0, 0, 0, 0, 0, 1, 0],
                              [0, 0, 0, 0, 0, 0, 1]])
        self.kf.H = np.array(
            [[1, 0, 0, 0, 0, 0, 0],
             [0, 1, 0, 0, 0, 0, 0],
             [0, 0, 1, 0, 0, 0, 0],
             [0, 0, 0, 1, 0, 0, 0]])

        self.kf.R[2:, 2:] *= 10.
        self.kf.P[4:, 4:] *= 1000.  # give high uncertainty to the unobservable initial velocities
        self.kf.P *= 10.
        self.kf.Q[-1, -1] *= 0.01
        self.kf.Q[4:, 4:] *= 0.01

        self.kf.x[:4] = convert_bbox_to_z(bbox)
        self.time_since_update = 0
        KalmanBoxTracker.count += 1
        self.id = KalmanBoxTracker.count
        self.history = []
        self.hits = 0
        self.hit_streak = 0
        self.age = 0
        self.score = score

    # def update(self, bbox, score):
    def update(self, bbox, score, is_matched):
        """
        Updates the state vector with observed bbox.
        """
        self.time_since_update = 0
        self.history = []
        self.hits += 1
        self.hit_streak += 1
        # Also consider the predictions.
        # else:
        self.kf.update(convert_bbox_to_z(bbox))
        # Trust the detections.
        if is_matched:
            self.kf.x[:4] = convert_bbox_to_z(bbox)
        self.score = score

    def predict(self):
        """
        Advances the state vector and returns the predicted bounding box estimate.
        """
        if (self.kf.x[6] + self.kf.x[2]) <= 0:
            self.kf.x[6] *= 0.0
        self.kf.predict()
        self.age += 1
        if self.time_since_update > 0:
            self.hit_streak = 0
        self.time_since_update += 1
        self.history.append(convert_x_to_bbox(self.kf.x))
        return self.history[-1]

    def get_state(self):
        """
        Returns the current bounding box estimate.
        """
        return convert_x_to_bbox(self.kf.x)


def associate_detections_to_trackers(detections, trackers, iou_threshold=0.1):
    """
    Assigns detections to tracked object (both represented as bounding boxes)

    Returns 3 lists of matches, unmatched_detections and unmatched_trackers
    """
    if len(trackers) == 0:
        return np.empty((0, 2), dtype=int), np.arange(len(detections)), np.empty((0, 5), dtype=int)

    iou_matrix = iou_batch(detections, trackers)

    if min(iou_matrix.shape) > 0:
        a = (iou_matrix > iou_threshold).astype(np.int32)
        if a.sum(1).max() == 1 and a.sum(0).max() == 1:
            matched_indices = np.stack(np.where(a), axis=1)
        else:
            matched_indices = linear_assignment(-iou_matrix)
    else:
        matched_indices = np.empty(shape=(0, 2))

    unmatched_detections = []
    for d, det in enumerate(detections):
        if d not in matched_indices[:, 0]:
            unmatched_detections.append(d)
    unmatched_trackers = []
    for t, trk in enumerate(trackers):
        if t not in matched_indices[:, 1]:
            unmatched_trackers.append(t)

    # filter out matched with low IOU
    matches = []
    for m in matched_indices:
        if iou_matrix[m[0], m[1]] < iou_threshold:
            unmatched_detections.append(m[0])
            unmatched_trackers.append(m[1])
        else:
            matches.append(m.reshape(1, 2))
    if len(matches) == 0:
        matches = np.empty((0, 2), dtype=int)
    else:
        matches = np.concatenate(matches, axis=0)

    # Bind exactly one unmatched detection and one unmatched tracker
    if len(unmatched_detections) == 1 and len(unmatched_trackers) == 1:
        matches = np.concatenate((matches, np.array([[unmatched_detections[0], unmatched_trackers[0]]])), axis=0)
        unmatched_detections = []
        unmatched_trackers = []

    return matches, np.array(unmatched_detections), np.array(unmatched_trackers)


def mse_batch(dets, trks):
    """
    Returns a matrix of MSE between each det and trk.
    """
    # Get only the bounding box coordinates (ignore the scores)
    dets_bboxes = dets[:, :4]
    trks_bboxes = trks[:, :4]

    # Expand dims to broadcast and calculate MSE for each pair
    dets_expanded = np.expand_dims(dets_bboxes, axis=1)  # shape (N, 1, 4)
    trks_expanded = np.expand_dims(trks_bboxes, axis=0)  # shape (1, M, 4)

    # Calculate MSE between all dets and trks
    mse_matrix = np.mean((dets_expanded - trks_expanded) ** 2, axis=2)  # shape (N, M)

    return mse_matrix


def match_dets_trks_with_mse(dets, trks):
    """
    Matches detection bboxes to tracker bboxes using MSE as the cost metric.
    """
    if len(dets) == 0 or len(trks) == 0:
        return []

    # Calculate the MSE cost matrix
    mse_matrix = mse_batch(dets, trks)

    # Use the linear sum assignment to find the best matches
    det_indices, trk_indices = linear_sum_assignment(mse_matrix)
    matches = []

    for det_idx, trk_idx in zip(det_indices, trk_indices):
        matches.append([det_idx, trk_idx])

    return matches


class Sort(object):
    def __init__(self, max_age=1, min_hits=3, iou_threshold=0.1):
        """
        Sets key parameters for SORT
        """
        self.max_age = max_age
        self.min_hits = min_hits
        self.iou_threshold = iou_threshold
        self.trackers = []
        self.frame_count = 0
        self.protected = []
        self.recovery_mode = False

    def add_protected(self, protected):
        self.protected = protected
        print(f"[LOG] Added protected: {protected}.")

        self.trackers = [trk for trk in self.trackers if trk.id in protected]

    def update(self, dets=np.empty((0, 5))):
        """
        Params: dets - a numpy array of detections in the format [[x1,y1,x2,y2,score],[x1,y1,x2,y2,score],...]
        Requires: this method must be called once for each frame even with empty detections (use np.empty((0,
        5)) for frames without detections). Returns a similar array, where the last column is the object ID.

        NOTE: The number of objects returned may differ from the number of detections provided.
        """
        self.frame_count += 1

        empty_dets = dets.shape[0] == 0

        # get predicted locations from existing trackers.
        trks = np.zeros((len(self.trackers), 5))
        to_del = []
        ret = []
        for t, trk in enumerate(trks):
            pos = self.trackers[t].predict()[0]
            trk[:] = [pos[0], pos[1], pos[2], pos[3], 0]
            if np.any(np.isnan(pos)):
                to_del.append(t)
        trks = np.ma.compress_rows(np.ma.masked_invalid(trks))
        for t in reversed(to_del):
            self.trackers.pop(t)
        matched, unmatched_dets, unmatched_trks = associate_detections_to_trackers(dets, trks, self.iou_threshold)

        # Track all detected objects.
        if not self.protected:
            # update matched trackers with assigned detections
            for m in matched:
                self.trackers[m[1]].update(dets[m[0], :], dets[m[0], -1], is_matched=True)

            # create and initialise new trackers for unmatched detections
            for i in unmatched_dets:
                trk = KalmanBoxTracker(dets[i, :], dets[i, -1])
                self.trackers.append(trk)

            i = len(self.trackers)
            unmatched = []
            for trk in reversed(self.trackers):
                d = trk.get_state()[0]
                if (trk.time_since_update < 1) and (
                        trk.hit_streak >= self.min_hits or self.frame_count <= self.min_hits):
                    # +1 as MOT benchmark requires positive
                    ret.append(np.concatenate((d, [trk.score, trk.id])).reshape(1, -1))
                i -= 1
                # remove dead tracklet
                if trk.time_since_update > self.max_age:
                    self.trackers.pop(i)
                if empty_dets:
                    unmatched.append(np.concatenate((d, [trk.score, trk.id])).reshape(1, -1))

            if len(ret):
                return np.concatenate(ret)
            elif empty_dets:
                return np.concatenate(unmatched) if len(unmatched) else np.empty((0, 6))
            return np.empty((0, 6))

        # Track only the players - do not remove and do not add anyone.
        else:
            if not len(unmatched_trks):
                self.recovery_mode = False
                # update matched trackers with assigned detections
                for m in matched:
                    self.trackers[m[1]].update(dets[m[0], :], dets[m[0], -1], is_matched=True)

                for trk in reversed(self.trackers):
                    d = trk.get_state()[0]
                    if trk.hit_streak >= self.min_hits or self.frame_count <= self.min_hits:
                        ret.append(np.concatenate((d, [trk.score, trk.id])).reshape(1, -1))

                if len(ret):
                    return np.concatenate(ret)

                return np.empty((0, 6))

            elif len(unmatched_trks) and not self.recovery_mode:
                self.recovery_mode = True
                for trk in reversed(self.trackers):
                    d = trk.get_state()[0]
                    ret.append(np.concatenate((d, [trk.score, trk.id])).reshape(1, -1))

                return np.concatenate(ret)

            elif len(unmatched_trks) and self.recovery_mode:

                matched = match_dets_trks_with_mse(dets, trks)

                for m in matched:
                    self.trackers[m[1]].update(dets[m[0], :], dets[m[0], -1], is_matched=True)

                for trk in reversed(self.trackers):
                    d = trk.get_state()[0]
                    if trk.hit_streak >= self.min_hits or self.frame_count <= self.min_hits:
                        ret.append(np.concatenate((d, [trk.score, trk.id])).reshape(1, -1))

                if len(ret):
                    return np.concatenate(ret)

                return np.empty((0, 6))

        return np.empty((0, 6))

    def reset(self):
        self.trackers.clear()
        KalmanBoxTracker.count = 0  # Reset ID's back to 1.
        self.protected = []
        self.frame_count = 0
        self.recovery_mode = False
