## Dance Scoring Algorithm

This folder contains the dance scoring algorithm, implemented as a gRPC server that interacts with the Flutter app, providing real-time scoring based on the player's dance moves.

### Overview
The algorithm leverages advanced computer vision techniques for human pose estimation, object tracking, and pose comparison to score the player's performance. It integrates multiple components to ensure accurate and consistent scoring throughout the game.

### Key Components

- **Human Pose Estimation**: 
  The algorithm utilizes a pose estimation model to detect key body points (e.g., wrists, elbows, knees) in real-time. These detected points form the basis for comparing the player's movements to pre-recorded dance sequences.


- **YOLO for Player Detection**:
  YOLO (You Only Look Once) is employed to detect and locate the player within each video frame. This ensures that the system focuses exclusively on the player's movements during gameplay.


- **SORT Tracking with Custom Optimizations**:
  SORT (Simple Online and Realtime Tracking) is used to maintain consistent tracking of the player across frames. We've implemented custom optimizations to ensure that the player's tracker remains intact, even during momentary detection failures (e.g., rapid or occluded movements). This prevents the system from mistakenly losing track of the player, ensuring smooth scoring throughout the game.


- **Pose Comparison using Angular Similarity**:
  The player's detected poses are compared to reference dance poses using an angular comparison technique. The angles between key joints (e.g., arms, legs) are computed and then compared to the corresponding angles in the pre-recorded dance sequence.


- **Temporal Windowing and Edge Punishment**:
  To ensure accurate scoring over time, the algorithm evaluates the player's poses in short time windows, corresponding to the dance's time-based sequence. Each window contains several consecutive poses. The algorithm compares the player's current poses with the reference poses within the same window, and it penalizes comparison values near the edges of the window to account for natural variability and slight delays in movement. The final output is the minimal comparison value from this window.


- **Additional Features**:
  The algorithm also includes features such as converting comparison values to scores, stabilizing scores to avoid sudden fluctuations, and approximating the total score for each performance. These features ensure a smooth and fair scoring experience during gameplay.

