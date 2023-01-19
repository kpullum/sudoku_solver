import 'package:flutter/material.dart';
import 'package:sudoku/sudoku.dart';

void main() {
  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Solver',
      home: const MainPage(title: 'Sudoku Home Page'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Segoe UI Semibold'
          ),
            titleLarge:  TextStyle(
              color: Colors.red,
                fontFamily: 'Segoe UI Semibold'
            )
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                width: 20
              )
            )
          )
        )
      )
    );
  }
}

class MainPage extends StatefulWidget {

  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(),
              child: const Image(
                image: AssetImage('images/title.png')
              ),
            ),
            Text(
                'Simple solutions for the world\'s favorite puzzle game!\n\nTap the button to start:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall
            ),
            OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const _SudokuPage(title: 'Solve Sudoku')),
                  );
                },
              style: OutlinedButton.styleFrom(
                  // fixedSize: const Size.fromHeight(100),
                  shape: const StadiumBorder()
              ),
              child: Text(
                'START',
                style: Theme.of(context).textTheme.titleLarge
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SudokuPage extends StatefulWidget {

  const _SudokuPage({super.key, required this.title});
  final String title;

  @override
  State<_SudokuPage> createState() => _SudokuPageState();
}

class _SudokuPageState extends State<_SudokuPage> {

  int activeNum = 0;
  List<int> previousEntries = List.empty(growable: true);
  List<int> board = List.generate(81, (index) =>  0);
  String topText = 'Enter the known values:';

  void _updateBoard(int index) {
    setState(() {
      board[index] = activeNum;
      previousEntries.add(index);
    });
  }

  void _undoMove() {
    if(previousEntries.isNotEmpty) {
      setState(() {
        var i = previousEntries.removeLast();
        board[i] = 0;
      });
    }
  }

  void _solvePuzzle() {
    setState(() {topText = 'Solving puzzle...';});
    bool failed = false;
    List<List<int>> solvedBoard = Sudoku.solveBoard(board);
    for(List<int> row in solvedBoard) {
      if(row.every((element) => element == 0)){
        failed = true;
      }
    }
    setState(() {
      if(!failed){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                _ResultPage(title: 'Solve Sudoku', result: solvedBoard))
        );
      }
      else {
        topText = 'Could not find a solution. Please re-enter:';
      }
    });
  }

  static void _showPopup(BuildContext context, String message, Function onYes){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(),
            contentPadding: const EdgeInsets.symmetric(),
            content: Column(
              children: [
                Text(message),
                ButtonBar(
                    children: <Widget> [
                      OutlinedButton(
                          onPressed: onYes(),
                          child: const Text('Yes')
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No'),
                      )
                    ]
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                topText,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Segoe UI Semibold',
                ),
              ),
              buildBoard(context),
              Column(
                children: [
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                        return Builder(builder: (BuildContext context) {
                          return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: const CircleBorder()
                              ),
                              onPressed: () {
                                debugPrint('${index + 1} pressed');
                                activeNum = index + 1;
                                debugPrint('activeNum: $activeNum');
                              },
                              child: Text(
                                  '${index + 1}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Segoe UI Symbol',
                                    color: Colors.black,

                                ),
                              )
                          );
                        });
                    }),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Builder(builder: (BuildContext context) {
                        return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: const CircleBorder()
                            ),
                            onPressed: () {
                              debugPrint('${index + 6} pressed');
                              activeNum = index + 6;
                              debugPrint('activeNum: $activeNum');
                            },
                            child: Text(
                              '${index + 6}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Segoe UI Symbol',
                                color: Colors.black,
                              ),
                            )
                        );
                      });
                    }),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed:() {
                  _solvePuzzle();
                },
                style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text(
                  'SOLVE',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Segoe UI Semibold'
                  )
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        debugPrint('Quitting... ');
                        // setState(() {
                        //   _showPopup(context,
                        //       'Are you sure you want to return to the home screen? (Puzzle will not be saved)',
                        //           () => Navigator.pop(context)
                        //   );
                        //  }
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                      child: const Text(
                          'QUIT'
                      )
                  ),
                  OutlinedButton(
                      onPressed: () {
                        _undoMove();
                      },
                      style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                      child: const Text(
                        'UNDO'
                      )
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  GridView buildBoard(BuildContext context)  {
    return GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9
        ),
        shrinkWrap: true,
        children: List.generate(81, (index) {
          return Builder(builder: (context) {
            return OutlinedButton(
              onPressed: () {
                setState(() {
                  debugPrint('${index + 1} pressed');
                  _updateBoard(index);
                  debugPrint('board[index]: ${board[index]}');
                });
              },
              child: Text(
                board[index] == 0 ? '' : '${board[index]}',
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Tahoma',
                    color: Colors.black
                ),
              ),
            );
          });
        })
    );
  }
}

class _ResultPage extends StatefulWidget {

  const _ResultPage({super.key, required this.title, required this.result});
  final List<List<int>> result;
  final String title;

  @override
  State<_ResultPage> createState() => _ResultPageState();
  List<List<int>> getResult() => result;
}

class _ResultPageState extends State<_ResultPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Solution found!'),
              GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 9
                  ),
                  shrinkWrap: true,
                  children: List.generate(81, (index) {
                    return Builder(builder: (context) {
                      return OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          '${widget.result[(index ~/ 9)][index % 9]}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Tahoma',
                              color: Colors.black
                          ),
                        ),
                      );
                    });
                  })
                ),
              OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('RETURN'))
            ],
          ),
       )
    );
  }
}