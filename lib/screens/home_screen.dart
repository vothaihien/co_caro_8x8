import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text("Caro 8x8"),
        centerTitle: true,
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          // Hiển thị thông báo khi không có mạng.
          if (gameProvider.networkMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(gameProvider.networkMessage!),
                  duration: const Duration(seconds: 3),
                  backgroundColor: gameProvider.networkMessage!.contains("restored")
                  ? Colors.green
                  : Colors.red,
                )
              );
            });
          }
          // Hiển thị thông báo thắng/thua/hòa.
          if (gameProvider.gameStatus.contains('Wins') ||
              gameProvider.gameStatus.contains('Draw')) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Text(gameProvider.gameStatus),
                  actions: [
                    TextButton(
                      onPressed: () {
                        gameProvider.resetGame();
                        Navigator.of(context).pop();
                      },
                      child: const Text('New Game'),
                    ),
                  ],
                ),
              );
            });
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  gameProvider.gameStatus,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: 64,
                  itemBuilder: (context, index) {
                    final row = index ~/ 8;
                    final col = index % 8;
                    final cell = gameProvider.board[row][col];
                    final isLastMove =
                        gameProvider.lastMove == 'X$row$col' ||
                            gameProvider.lastMove == 'O$row$col';

                    return GestureDetector(
                      onTap: () => gameProvider.makeMove(row, col),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: isLastMove ? Colors.yellow[100] : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            cell,
                            style: TextStyle(
                              fontSize: 24,
                              color: cell == 'X'
                                  ? Colors.blue
                                  : cell == 'O'
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (gameProvider.isLoading)
                const CircularProgressIndicator(),
              Container(
                margin: EdgeInsets.only(bottom: 60),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: gameProvider.resetGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text('New Game'),

                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
