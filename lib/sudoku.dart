import 'package:flutter/material.dart';

class Sudoku {

  static List<List<int>> solvedBoard = [[0], [0]];
  static bool finished = false;

  static List<List<int>> solveBoard(List<int> unsolvedBoard) {

    // var rng = Random();
    // List<int> unsolvedBoard = List.generate(81, (index) => rng.nextInt(9));
    List<List<int>> empty = List.generate(9, (row) => List.generate(9, (col)  => 0));
    if(unsolvedBoard.every((element) => element == 0)) {
      return empty;
    }
    debugPrint(unsolvedBoard.toString());
    solvedBoard = List.generate(9, (row) => List.generate(9, (col)  => unsolvedBoard.elementAt((row * 9) + col)));
    debugPrint(solvedBoard.toString());
    if(_solve(0, 0)) {
      debugPrint(solvedBoard.toString());
      return solvedBoard;
    } else {
      debugPrint('Unable to find a solution, please try again.');
      debugPrint(solvedBoard.toString());
      return empty;
    }
  }

  static bool _solve(int r, int c) {

    // Return true at last index
    if(r == 8 && c == 9){
      return true;
    }

    int row = r;
    int col = c;

    if(col == 9){
      row = row + 1;
      col = 0;
    }

    if(solvedBoard[row][col] != 0){
      return _solve(row, col + 1);
    }

    for(int num = 1; num <= 9; num++){
      if(_validMove(num, row, col)){
        solvedBoard[row][col] = num;

        if(_solve(row, col + 1)) {
          return true;
        }
        // Undo assignment and backtrack
        solvedBoard[row][col] = 0;
      }
    }

    return false;
  }

  static bool _validMove(int num, int row, int col) {

    // Check row
    for(var i = 0; i < 9; i++) {
      if(solvedBoard.elementAt(row).elementAt(i) == num) {
        return false;
      }
    }

    // Check column
    for(var j = 0; j < 9; j++) {
      if(solvedBoard.elementAt(j).elementAt(col) == num) {
        return false;
      }
    }

    // Check square
    int startRow = row - (row % 3);
    int startCol = col - (col % 3);
    for(var k = 0; k < 3; k++) {
      for(var l = 0; l < 3; l++) {
        if(solvedBoard.elementAt(k + startRow).elementAt(l + startCol) == num) {
          return false;
        }
      }
    }
    return true;
  }
} // Sudoku