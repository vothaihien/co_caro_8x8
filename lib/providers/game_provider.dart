import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_move_request.dart';
import '../services/api_service.dart';

class GameProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  final ApiService _apiService;
  List<List<String>> board = List.generate(8, (_) => List.generate(8, (_) => ''));
  List<Map<String, int>> playerMoves = [];
  List<Map<String, int>> cpuMoves = [];
  bool isPlayerTurn = true;
  bool isLoading = false;
  String? lastMove;
  String gameStatus = 'Player X\'s turn';

  GameProvider(this._prefs, this._apiService) {
    _loadGame();
  }

  void _loadGame() {
    final savedGame = _prefs.getString('game_state');
    if (savedGame != null) {
      final data = jsonDecode(savedGame);
      board = (data['board'] as List)
          .map((row) => (row as List).cast<String>())
          .toList();
      playerMoves = (data['playerMoves'] as List)
          .map((move) => Map<String, int>.from(move))
          .toList();
      cpuMoves = (data['cpuMoves'] as List)
          .map((move) => Map<String, int>.from(move))
          .toList();
      isPlayerTurn = data['isPlayerTurn'];
      gameStatus = data['gameStatus'];
      notifyListeners();
    }
  }

  void _saveGame() {
    final data = {
      'board': board,
      'playerMoves': playerMoves,
      'cpuMoves': cpuMoves,
      'isPlayerTurn': isPlayerTurn,
      'gameStatus': gameStatus,
    };
    _prefs.setString('game_state', jsonEncode(data));
  }

  void resetGame() {
    board = List.generate(8, (_) => List.generate(8, (_) => ''));
    playerMoves = [];
    cpuMoves = [];
    isPlayerTurn = true;
    isLoading = false;
    lastMove = null;
    gameStatus = 'Player X\'s turn';
    _prefs.remove('game_state');
    notifyListeners();
  }

  Future<void> makeMove(int row, int col) async {
    if (board[row][col].isNotEmpty || !isPlayerTurn || isLoading) return;

    board[row][col] = 'X';
    playerMoves.add({'x': row, 'y': col});
    lastMove = 'X$row$col';
    isPlayerTurn = false;
    gameStatus = 'AI\'s turn';
    _saveGame();
    notifyListeners();

    if (_checkWin('X')) {
      gameStatus = 'Player X wins!';
      _showResultDialog();
      return;
    }
    if (_isBoardFull()) {
      gameStatus = 'Draw!';
      _showResultDialog();
      return;
    }

    await _makeAiMove();
  }

  Future<void> _makeAiMove() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getAiMove(
        AiMoveRequest(
          board: [8, 8],
          player: playerMoves,
          cpu: cpuMoves,
        ),
      );
      board[response.data.cpu_move.x][response.data.cpu_move.y] = 'O';
      cpuMoves.add({'x': response.data.cpu_move.x, 'y': response.data.cpu_move.y});
      lastMove = 'O${response.data.cpu_move.x}${response.data.cpu_move.y}';
      isPlayerTurn = true;
      gameStatus = 'Player X\'s turn';
      _saveGame();
      notifyListeners();

      if (_checkWin('O')) {
        gameStatus = 'AI wins!';
        _showResultDialog();
      } else if (_isBoardFull()) {
        gameStatus = 'Draw!';
        _showResultDialog();
      }
    } catch (e) {
      gameStatus = 'Error fetching AI move: $e';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool _checkWin(String symbol) {
    // Check rows
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j <= 3; j++) {
        if (board[i][j] == symbol &&
            board[i][j + 1] == symbol &&
            board[i][j + 2] == symbol &&
            board[i][j + 3] == symbol &&
            board[i][j + 4] == symbol) {
          return true;
        }
      }
    }
    // Check columns
    for (int i = 0; i <= 3; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == symbol &&
            board[i + 1][j] == symbol &&
            board[i + 2][j] == symbol &&
            board[i + 3][j] == symbol &&
            board[i + 4][j] == symbol) {
          return true;
        }
      }
    }
    // Check diagonals
    for (int i = 0; i <= 3; i++) {
      for (int j = 0; j <= 3; j++) {
        if (board[i][j] == symbol &&
        board[i + 1][j + 1] == symbol &&
        board[i + 2][j + 2] == symbol &&
        board[i + 3][j + 3] == symbol &&
        board[i + 4][j + 4] == symbol) {
          return true;
        }
      }
    }
    for (int i = 0; i <= 3; i++) {
      for (int j = 4; j < 8; j++) {
        if (board[i][j] == symbol &&
            board[i + 1][j - 1] == symbol &&
            board[i + 2][j - 2] == symbol &&
            board[i + 3][j - 3] == symbol &&
            board[i + 4][j - 4] == symbol) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isBoardFull() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void _showResultDialog() {
    notifyListeners();
  }
}

