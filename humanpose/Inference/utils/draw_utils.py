import cv2
import numpy as np
import matplotlib.pyplot as plt


def joints_dict():
    joints = {
         "coco": {
            "keypoints": {
                0: "nose",
                1: "left_eye",
                2: "right_eye",
                3: "left_ear",
                4: "right_ear",
                5: "left_shoulder",
                6: "right_shoulder",
                7: "left_elbow",
                8: "right_elbow",
                9: "left_wrist",
                10: "right_wrist",
                11: "left_hip",
                12: "right_hip",
                13: "left_knee",
                14: "right_knee",
                15: "left_ankle",
                16: "right_ankle"
            },
            "skeleton": [
                [15, 13], [13, 11], [16, 14], [14, 12], [11, 12], [5, 11], [6, 12],
                [5, 6], [5, 7], [6, 8], [7, 9], [8, 10], [1, 2], [0, 1],
                [0, 2], [1, 3], [2, 4], [0, 5], [0, 6]
            ]}}

    return joints


def draw_bboxes(image, bounding_boxes, boxes_id, scores):
    image_with_boxes = image.copy()

    for bbox, bbox_id, score in zip(bounding_boxes, boxes_id, scores):
        x1, y1, x2, y2 = bbox
        cv2.rectangle(image_with_boxes, (x1, y1), (x2, y2), (128, 128, 0), 2)

        label = f'#{bbox_id}: {score:.2f}'

        (label_width, label_height), _ = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.5, 1)
        label_x = x1
        label_y = y1 - 5 if y1 > 20 else y1 + 20

        # Draw a filled rectangle as the background for the label
        cv2.rectangle(image_with_boxes, (x1, label_y - label_height - 5),
                      (x1 + label_width, label_y + 5), (128, 128, 0), cv2.FILLED)
        cv2.putText(image_with_boxes, label, (label_x, label_y),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0), 1)

    return image_with_boxes


def draw_points(image, points, color_palette='tab20', palette_samples=16, confidence_threshold=0.5):
    """
    Draws `points` on `image`.

    Args:
        image: image in opencv format
        points: list of points to be drawn.
            Shape: (nof_points, 3)
            Format: each point should contain (y, x, confidence)
        color_palette: name of a matplotlib color palette
            Default: 'tab20'
        palette_samples: number of different colors sampled from the `color_palette`
            Default: 16
        confidence_threshold: only points with a confidence higher than this threshold will be drawn. Range: [0, 1]
            Default: 0.5

    Returns:
        A new image with overlaid points

    """
    try:
        colors = np.round(
            np.array(plt.get_cmap(color_palette).colors) * 255
        ).astype(np.uint8)[:, ::-1].tolist()
    except AttributeError:  # if palette has not pre-defined colors
        colors = np.round(
            np.array(plt.get_cmap(color_palette)(np.linspace(0, 1, palette_samples))) * 255
        ).astype(np.uint8)[:, -2::-1].tolist()

    circle_size = max(1, min(image.shape[:2]) // 150)  # ToDo Shape it taking into account the size of the detection
    # circle_size = max(2, int(np.sqrt(np.max(np.max(points, axis=0) - np.min(points, axis=0)) // 16)))

    for i, pt in enumerate(points):
        if pt[2] > confidence_threshold:
            image = cv2.circle(image, (int(pt[1]), int(pt[0])), circle_size, tuple(colors[i % len(colors)]), -1)

    return image


def draw_skeleton(image, points, skeleton, color_palette='Set2', palette_samples=8, person_index=0,
                  confidence_threshold=0.5):
    """
    Draws a `skeleton` on `image`.

    Args:
        image: image in opencv format
        points: list of points to be drawn.
            Shape: (nof_points, 3)
            Format: each point should contain (y, x, confidence)
        skeleton: list of joints to be drawn
            Shape: (nof_joints, 2)
            Format: each joint should contain (point_a, point_b) where `point_a` and `point_b` are an index in `points`
        color_palette: name of a matplotlib color palette
            Default: 'Set2'
        palette_samples: number of different colors sampled from the `color_palette`
            Default: 8
        person_index: index of the person in `image`
            Default: 0
        confidence_threshold: only points with a confidence higher than this threshold will be drawn. Range: [0, 1]
            Default: 0.5

    Returns:
        A new image with overlaid joints

    """
    try:
        colors = np.round(
            np.array(plt.get_cmap(color_palette).colors) * 255
        ).astype(np.uint8)[:, ::-1].tolist()
    except AttributeError:  # if palette has not pre-defined colors
        colors = np.round(
            np.array(plt.get_cmap(color_palette)(np.linspace(0, 1, palette_samples))) * 255
        ).astype(np.uint8)[:, -2::-1].tolist()

    for i, joint in enumerate(skeleton):
        pt1, pt2 = points[joint]
        if pt1[2] > confidence_threshold and pt2[2] > confidence_threshold:
            image = cv2.line(
                image, (int(pt1[1]), int(pt1[0])), (int(pt2[1]), int(pt2[0])),
                tuple(colors[person_index % len(colors)]), 2
            )

    return image


def draw_points_and_skeleton(image, points, skeleton, points_color_palette='tab20', points_palette_samples=16,
                             skeleton_color_palette='Set2', skeleton_palette_samples=8, person_index=0,
                             confidence_threshold=0.5):
    """
    Draws `points` and `skeleton` on `image`.

    Args:
        image: image in opencv format
        points: list of points to be drawn.
            Shape: (nof_points, 3)
            Format: each point should contain (y, x, confidence)
        skeleton: list of joints to be drawn
            Shape: (nof_joints, 2)
            Format: each joint should contain (point_a, point_b) where `point_a` and `point_b` are an index in `points`
        points_color_palette: name of a matplotlib color palette
            Default: 'tab20'
        points_palette_samples: number of different colors sampled from the `color_palette`
            Default: 16
        skeleton_color_palette: name of a matplotlib color palette
            Default: 'Set2'
        skeleton_palette_samples: number of different colors sampled from the `color_palette`
            Default: 8
        person_index: index of the person in `image`
            Default: 0
        confidence_threshold: only points with a confidence higher than this threshold will be drawn. Range: [0, 1]
            Default: 0.5

    Returns:
        A new image with overlaid joints

    """
    image = draw_skeleton(image, points, skeleton, color_palette=skeleton_color_palette,
                          palette_samples=skeleton_palette_samples, person_index=person_index,
                          confidence_threshold=confidence_threshold)
    image = draw_points(image, points, color_palette=points_color_palette, palette_samples=points_palette_samples,
                        confidence_threshold=confidence_threshold)
    return image

