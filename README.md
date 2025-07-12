# Caro 8x8 Game

## Overview
Caro 8x8 is a Flutter-based mobile application implementing the classic Tic-Tac-Toe (Caro) game on an 8x8 board. The player (X) competes against an AI opponent (O), with the goal of aligning five consecutive symbols horizontally, vertically, or diagonally. The app integrates with a RESTful API to fetch AI moves, persists game state using `shared_preferences`, and handles network connectivity changes with user-friendly notifications.

## Features
- **8x8 Game Board**: Displays an 8x8 grid using Flutter's `GridView`, with X (blue) for the player, O (red) for the AI, and empty cells.
- **Turn-Based Gameplay**: Players alternate turns, with the player (X) going first. Invalid moves (e.g., clicking occupied cells) are prevented.
- **Win/Draw Detection**: Checks for five consecutive symbols (horizontal, vertical, diagonal) to determine a win, or a draw when the board is full.
- **AI Integration**: Fetches AI moves via a RESTful API using `retrofit` and `dio`, with a loading indicator during API calls.
- **Game State Persistence**: Saves and restores game state (board, moves, turn, status) using `shared_preferences`.
- **Result Dialog**: Displays a dialog when the game ends (win, loss, or draw) with an option to start a new game.
- **Network Handling**: Shows user-friendly `SnackBar` notifications when the internet connection is lost ("No internet connection. Please check your network.") or restored ("Internet connection restored.").
- **Highlight Last Move**: The most recent move is highlighted in light yellow for better visibility.
- **State Management**: Uses `provider` for efficient state management and UI updates.

## Requirements
- Flutter SDK: >=3.0.0 <4.0.0
- Dart: >=3.0.0 <4.0.0
- Dependencies (see `pubspec.yaml`):
    - `provider: ^6.0.0`
    - `shared_preferences: ^2.0.0`
    - `dio: ^5.0.0`
    - `retrofit: ^4.0.0`
    - `json_annotation: ^4.8.0`
    - `connectivity_plus: ^6.0.0`
    - Dev dependencies: `retrofit_generator`, `build_runner`, `json_serializable`

## Installation
1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd caro_game
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Code for Retrofit and JSON Serialization**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure API Endpoint**:
    - Open `lib/api_service.dart`.
    - Replace `https://your-api-endpoint.com/` with the actual API URL (e.g., `https://example.com/api/`).
    - Ensure the API supports a POST endpoint `/get-ai-move` with the following request and response format:
        - **Request**: `{ "board": [8, 8], "player": [{"x": int, "y": int}, ...], "cpu": [{"x": int, "y": int}, ...] }`
        - **Response**: `{ "message": "Move done", "data": { "cpu_move": { "x": int, "y": int } } }`

5. **Add Platform Permissions**:
    - **Android** (`android/app/src/main/AndroidManifest.xml`):
      ```xml
      <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
      ```
    - **iOS** (`ios/Runner/Info.plist`):
      ```xml
      <key>NSAppTransportSecurity</key>
      <dict>
          <key>NSAllowsArbitraryLoads</key>
          <true/>
      </dict>
      ```

6. **Run the App**:
   ```bash
   flutter run
   ```

## Usage
- **Start the Game**: Launch the app to see an 8x8 grid. The player (X) goes first.
- **Make a Move**: Tap an empty cell to place an X. The AI (O) responds with a move fetched from the API.
- **View Game Status**: The current turn or game result is displayed above the board (e.g., "Player X's turn", "AI wins!").
- **Network Notifications**: If the internet is disconnected, a `SnackBar` shows "No internet connection. Please check your network." When reconnected, it shows "Internet connection restored."
- **Game Over**: A dialog appears when a player wins (5 consecutive symbols) or the game draws (board full), with a "New Game" button to restart.
- **Reset Game**: Tap the "New Game" button below the board to start a new game at any time.
- **Persistent State**: The game state is saved automatically and restored when the app is reopened.

## Project Structure
```
caro_game/
├── lib/
│   ├── main.dart              # App entry point, sets up MultiProvider
│   ├── models/                # Catch data call from API
│   ├── services/              # Defines REST API client using Retrofit
│   ├── providers              # Manages game state, API calls, and network status
│   ├── screens                # Renders the game UI (board, status, dialog, SnackBar)
├── pubspec.yaml               # Dependencies and project configuration
├── README.md                  # Project documentation
```
