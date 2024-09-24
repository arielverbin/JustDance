# Just Dance🪩
A machine learning-based dancing game, using human pose estimation.

## Overview
Our **Just Dance App** is an interactive dance game that leverages advanced computer vision and machine learning techniques to track and score players' dance moves in real-time. The app utilizes human pose estimation, pose comparison algorithms, and real-time player tracking to provide an engaging and accurate dance scoring experience.

This project involves two main components:
1. A **Flutter-based desktop app** that provides the front-end interface for the game.
2. A **Python-based server** that runs locally on the user's machine, and is responsible for performing the pose estimation, tracking, and scoring algorithms, communicating with the app via gRPC.

## Key Features
1. **Human Pose Estimation**: Powered by the ViTPose model, which delivers highly accurate human pose keypoints by leveraging transformer-based architecture.
2. **Pose Comparision Algorithm**: This algorithm uses an angular-based comparison method to evaluate the player's pose against a short window of poses performed by the dancer around the corresponding time. A final comparison score is then generated, which is converted into a score displayed on the app in real-time.
3. **Human Tracking**: Implements SORT (Simple Online and Realtime Tracking), optimized with custom modifications to efficiently track multiple players in dynamic scenes.
4. **Camera Angle Independece**: The player can specify the angle at which their camera is positioned. The algorithm then knows to compare their dance movements to the dancer's pose sequence that was filmed from the most similar angle.

## App Screenshots

These screenshots show the following screens: the homepage, the camera angle adjustment screen, the game initialization screen, the in-game screen, and the winner screen, respectively.

<div align="center">
  <img src="./screenshots/homepage.png" alt="HomePage" width="45%" style="margin-right:10px;"/>
  <img src="./screenshots/angle_adjust.jpg" alt="CameraAngleAdjustment" width="45%"/>
</div>

<div align="center">
  <img src="./screenshots/game_start.png" alt="GameInitialization" width="45%" style="margin-right:10px;"/>
  <img src="./screenshots/in_game.jpg" alt="InGame" width="45%"/>
</div>

<div align="center">
  <img src="./screenshots/winner_page.png" alt="WinnerPage" width="45%" style="margin-right:10px;"/>
</div>

## Getting Started

### macOS Users
1. **Clone the Project:** Clone the repository to your local machine.

2. **Download Required Files:** Since these files were too large to be included in the Git repository, please download them from [here](https://drive.google.com/drive/folders/1KEBS4vHSfZPdqgpCSK7do0r8hSjc7tpv).
     - `vitpose-b-coco.pth` and `yolov8m.pt` to `/app/assets/pose-scoring/Inference/weights/`.
     - `seven-rings.mov` and `test-app.mov` to `/app/assets/songs/`.
     - `server.dist` to `/app/assets/pose-scoring/`.

3. **Install Dependencies:** Ensure that all necessary dependencies are installed. Refer to the `pubspec.yaml` file for Flutter dependencies, and install them as needed using:
     ```bash
     flutter pub get
     ```

4. **Run the App:** Use Flutter to run the app by navigating to the project directory and running:
     ```bash
     flutter run
     ```

<br></br>

### Non-macOS Users
1. **Clone the Project:** Clone the repository to your local machine.

2. **Download Required Files:** Since these files were too large to be included in the Git repository, please download them from [here](https://drive.google.com/drive/folders/1KEBS4vHSfZPdqgpCSK7do0r8hSjc7tpv).
     - `vitpose-b-coco.pth` and `yolov8m.pt` to `/app/assets/pose-scoring/Inference/weights/`.
     - `seven-rings.mov` and `test-app.mov` to `/app/assets/songs/`.

3. **Run the Server:** Navigate to the `humanpose` server directory and start the server:
     ```bash
     cd humanpose
     python3 server.py
     ```
   - Ensure that all dependencies listed in the `requirements.txt` file are installed.

4. **Run the App:** After the server is running, start the Flutter app using:
     ```bash
     flutter run
     ```

<br></br>

#### Platform Availability
The game is intended to be available on macOS, Windows, and Linux. However, it has only been tested on macOS at this time.


#### Note

The project’s methodology, including details on the algorithms used, is documented in files located within the `/reports/` folder. These files explain the technical approaches, steps, and processes employed throughout the project.

<br></br>
