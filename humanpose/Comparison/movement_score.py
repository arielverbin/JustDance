from Comparison.angular_score import joints
from Comparison.pose_sequence import PoseSequence
from Comparison.angular_score import AngularScore


class MovementScore:
    def __init__(self, target_sequence, approx_duration=1, window_duration=1, factor=2):
        """
        Initializes the MovementScore class.
        Args:
            - target_sequence: PoseSequence
                The dancer's pose sequence.
            - approx_duration: float
                The time interval in which the angular speed will be averaged.
            - window_duration: float
                The time interval in which we will compare the player's speed to each of the dancer's speeds.
            - factor: int
                Amount of significance given to high speeds, compared to low speeds.
        """
        assert isinstance(target_sequence, PoseSequence)

        self.approx_duration = approx_duration
        self.window_duration = window_duration
        self.bound_intervals = 0.09
        self.players = {}
        self.num_joints = len(joints)
        self.factor = factor
        self.fps = target_sequence.fps
        self.target_speeds = self.preprocess_target_speed(target_sequence)

        self.abort_threshold = 5

    def process_score(self, player_id, current_time, player_pose, score):
        if self.abort_threshold == 0:
            return score

        player_movement = self.update_movement(player_id, current_time, player_pose)

        # Player is moving rapidly: Slightly increase their score.
        # If their rapid movements does not match the dance - the score will anyway be low so *1.25 wouldn't change it.
        # If their movements are correct, the score might have slightly decrease due to timing differences.
        # In this case - *1.25 will help maintain a high score.
        if player_movement > 55:
            return score * 1.25

        # Player is somewhat moving, but not enough to penalize their score.
        if player_movement > 35:
            return score

        dancer_movements = self.get_target_speed_window(current_time)
        best_dance_movement = min(dancer_movements, key=lambda x: abs(x - player_movement))

        # Both dancer and player are not really moving, so score purely based on pose comparison.
        if best_dance_movement - player_movement < 25:
            return score

        print(f"PENALIZING: {player_movement:.4f} lower than {best_dance_movement:.4f}. TIME: {current_time:.4f}")
        # Dancer is moving but player isn't, penalize player to avoid moments of score increase.
        return score * (player_movement / (30 * 1.5))

    def get_target_speed_window(self, current_time):
        start_window = current_time - self.window_duration / 2
        end_window = current_time + self.window_duration / 2

        window = [speed for (time, speed) in self.target_speeds if start_window <= time <= end_window]
        return window if len(window) > 0 else [0]

    def preprocess_target_speed(self, target_sequence):
        target_sequence.preprocess_poses(AngularScore.process_pose)
        poses = target_sequence.preprocessed_poses

        self.players['target'] = {
            'poses': [],
            'speeds': [],
            'last-speed': 0,
            'last-time': 0
        }

        for i, pose in enumerate(poses):
            current_time = i * (1 / self.fps)
            self.players['target']['speeds'].append((current_time, self.update_movement(-1, current_time, pose)))

        result = self.players['target']['speeds']

        # Remove unused players.
        self.players.pop(-1)
        self.players.pop('target')
        return result

    def update_movement(self, player_id, current_time, player_pose):
        if player_id not in self.players:
            # Player is new.
            self.players[player_id] = {
                'poses': [(current_time, player_pose)],
                'speeds': [(0, 50)],
                'last-speed': 50,
                'last-time': current_time
            }
            return 0

        if current_time - self.players[player_id]['last-time'] < self.bound_intervals:
            return self.players[player_id]['last-speed']

        self.players[player_id]["poses"].append((current_time, player_pose))
        self.remove_old(player_id, current_time)

        player_movement = self.calculate_movement(player_id)

        avg_speed = sum([speed
                         for (time, speed) in self.players[player_id]['speeds']
                         ]) / (len(self.players[player_id]['speeds']) + 1e-5)

        self.players[player_id]['speeds'].append((current_time, player_movement))
        self.players[player_id]['last-time'] = current_time
        self.players[player_id]['last-speed'] = player_movement

        final_movement = 0.7 * avg_speed + 0.3 * player_movement

        print(f"PM: {final_movement:.4f}, time: {current_time:.4f}, TIME: {current_time:.4f}, "
              f"LEN POSES: {len(self.players[player_id]['poses'])},"
              f"LEN SPEEDS: {len(self.players[player_id]['speeds'])}")

        return final_movement

    def remove_old(self, player_id, current_time):
        """
        Removes poses that are outside the time window (older than approx_duration seconds).
        Returns True if any poses were deleted, otherwise returns False.
        """
        self.players[player_id]['poses'] = [
            (t, p) for (t, p) in self.players[player_id]['poses']
            if current_time - t <= self.approx_duration + 1e-5
        ]

        self.players[player_id]['speeds'] = [
            (t, p) for (t, p) in self.players[player_id]['speeds']
            if current_time - t <= self.approx_duration + 1e-5
        ]

    def calculate_movement(self, player_id):
        """
        Calculates a constant measuring the movement of the player.
        """
        avg_speeds = self.avg_speeds(player_id)

        movement = 0
        for joint in range(self.num_joints):
            movement += (abs(avg_speeds[joint]) ** self.factor) * joints[joint][2]

        return ((1 / self.num_joints) * movement) ** (1 / self.factor)

    def avg_speeds(self, player_id):
        """
        Calculates the average speed for all joints.

        Returns:
            A list of average speeds for all joints.
        """
        # Initialize total speeds and counts for each joint
        total_speeds = [0] * self.num_joints
        num_intervals = [0] * self.num_joints

        # Extract the list of (time, pose) measurements for the player
        measurements = self.players[player_id]["poses"]

        # Iterate over all consecutive pose measurements
        for i in range(1, len(measurements)):
            t1, pose1 = measurements[i - 1]
            t2, pose2 = measurements[i]

            delta_t = t2 - t1
            print(f"delta_t: {delta_t:.4f}", end=" ")

            if delta_t > 0:
                # For each joint, calculate the speed and accumulate it
                for joint in range(self.num_joints):
                    delta_v = pose2[joint] - pose1[joint]  # Angular difference for the joint
                    speed = delta_v / delta_t
                    total_speeds[joint] += speed
                    num_intervals[joint] += 1

        # Calculate the mean speed for each joint
        avg_speeds = []
        for joint in range(self.num_joints):
            if num_intervals[joint] > 0:
                avg_speed = total_speeds[joint] / num_intervals[joint]
            else:
                avg_speed = 0
            avg_speeds.append(avg_speed)

        return avg_speeds

    def was_removed(self):
        return self.abort_threshold == 0
