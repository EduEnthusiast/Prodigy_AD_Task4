import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeGame());
}

class TicTacToeGame extends StatelessWidget {
  const TicTacToeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> _board = List.generate(9, (_) => '');
  String _currentPlayer = 'X';
  bool _isGameOver = false;
  String _winner = '';
  List<int> _winningCombination = [];

  void _resetGame() {
    setState(() {
      _board = List.generate(9, (_) => '');
      _currentPlayer = 'X';
      _isGameOver = false;
      _winner = '';
      _winningCombination = [];
    });
  }

  void _makeMove(int index) {
    if (_board[index] == '' && !_isGameOver) {
      setState(() {
        _board[index] = _currentPlayer;
        _checkWinner();
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      });
    }
  }

  void _checkWinner() {
    const List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (_board[combination[0]] != '' &&
          _board[combination[0]] == _board[combination[1]] &&
          _board[combination[1]] == _board[combination[2]]) {
        _isGameOver = true;
        _winner = _board[combination[0]];
        _winningCombination = combination;
        return;
      }
    }

    if (!_board.contains('')) {
      _isGameOver = true;
      _winner = 'Draw';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(71, 30, 71, 233),
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _isGameOver ? 'Winner: $_winner' : 'Turn: $_currentPlayer',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _makeMove(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _board[index],
                            style: TextStyle(
                              fontSize: 80,
                              color: _board[index] == 'X'
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (_isGameOver && _winner != 'Draw')
                  CustomPaint(
                    painter: WinningLinePainter(_winningCombination),
                    child: Container(),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
              ),
              child: const Text('Reset Game'),
            ),
          ),
        ],
      ),
    );
  }
}

class WinningLinePainter extends CustomPainter {
  final List<int> winningCombination;

  WinningLinePainter(this.winningCombination);

  @override
  void paint(Canvas canvas, Size size) {
    if (winningCombination.isNotEmpty) {
      final paint = Paint()
        ..color = Colors.red
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round;

      final boardSize = size.width;
      final tileSize = boardSize / 3;

      final start = Offset(
        (winningCombination.first % 3) * tileSize + tileSize / 2,
        (winningCombination.first ~/ 3) * tileSize + tileSize / 2,
      );

      final end = Offset(
        (winningCombination.last % 3) * tileSize + tileSize / 2,
        (winningCombination.last ~/ 3) * tileSize + tileSize / 2,
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
