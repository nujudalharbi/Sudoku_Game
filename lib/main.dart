 // import 'dart:html';

// import 'dart:html';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

final List<int> _items = List<int>.generate(81, (int index) => index);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false ,

      home: const Sudoku(),
    );
  }
}
class Sudoku extends StatefulWidget {
  const Sudoku({Key? key}) : super(key: key);

  @override
  State<Sudoku> createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {
  List<BoxInner> boxInners = [];
  FocusClass focusClass = FocusClass();
  bool isFinish = false;
  String? tapBoxIndex;
  @override
  void initState(){
    generateSudoku();
    super.initState();
  }
  void generateSudoku(){
    isFinish = false;
    focusClass = new FocusClass();
    tapBoxIndex = null ;
    generatePuzzle();
    checkFinish();
    setState(() {

    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     ElevatedButton(onPressed: () =>  generatePuzzle(), child: Icon(Icons.refresh)),
      //   ],
      // )
      // ,
     body: SafeArea(
       child: Container(
         alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),

                // height: 400,
                width: double.maxFinite,
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: GridView.builder
                  (itemCount: 9 ,
                  shrinkWrap: true
                  ,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3 ,
          childAspectRatio: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5)
                  ,
                  // physics: ScrollPhysics(),

                   itemBuilder: (buildContext , index) {
                     BoxInner boxInner = boxInners[index]  ;

                  return Container(alignment:  Alignment.center,
                  child: GridView.builder
                    (
                    itemCount: boxInner.blokChars.length  ,
                    shrinkWrap: true
                    ,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3 ,
                        childAspectRatio: 1,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5)
                    ,
                    // physics: ScrollPhysics(),

                    itemBuilder: (buildContext , index) {

                      BlokChar blokChar = boxInner.blokChars[index];

                      return Container(alignment:  Alignment.center,
                        margin: EdgeInsets.all(5),

                        child: TextField(   decoration: InputDecoration(
                          
                        hintText:   "${blokChar.text}",

                        ),
                      ),
                      );
                    },

                  ),
                  );
                },

                ),
              ),
             // Expanded(
             //   child:Container(
             //     padding: EdgeInsets.all(20),
             //     alignment: Alignment.center,
             //     child : Row(
             //       children: [
             //         GridView.builder
             //           (itemCount:9 ,
             //           shrinkWrap: true , scrollDirection: Axis.horizontal
             //           ,
             //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3 ,
             //               childAspectRatio: 1,
             //               crossAxisSpacing:50,
             //               mainAxisSpacing: 5),physics: ScrollPhysics(),
             //
             //           itemBuilder: (buildContext , index) {
             //             return ElevatedButton(onPressed: (){},
             //               child: Text("Refresh"),
             //             );
             //           },
             //
             //         ),
                     Expanded(
                     child:

                     ElevatedButton(onPressed: () =>  generateSudoku(),
                     child: Text("Refresh"),

                     ),
                     )
                       // ),
                     // )
                   //-----------
            //        ],
            //      ),
            //    ),
            //   ),
            // //  -----
            ],
          ),
        ),
     ),
    );
  }

  generatePuzzle() {
    // boxInners.clear();
    var sudokuGenerator = SudokuGenerator(emptySquares: 54);
    List<List<List<int>>> completes = partition(sudokuGenerator.newSudokuSolved,
        sqrt(sudokuGenerator.newSudoku.length).toInt()).toList();
    partition(sudokuGenerator.newSudoku,
        sqrt(sudokuGenerator.newSudoku.length).toInt()).toList()
        .asMap()
        .entries
        .forEach((entry){
      List<int> tempListCompletes =
      completes[entry.key].expand((element) => element).toList();
      List<int> tempList = entry.value.expand((element) => element).toList();


      tempList.asMap().entries.forEach((entryIn){
        int index = entry.key * sqrt(sudokuGenerator.newSudoku.length).toInt() *
            (entryIn.key % 9 ).toInt() ~/ 3 ;
        if (boxInners.where((element) => element.index == index ).length == 0 ){
          boxInners.add(BoxInner(index , []));

        }
        BoxInner boxInner = boxInners.where((element) => element.index == index).first;
        boxInner.blokChars.add(BlokChar(
          entryIn.value == 0 ? "" : entryIn.value.toString(),
          index: boxInner.blokChars.length,
          isDefault : entryIn.value != 0,
          isCorrect : entryIn.value != 0 ,
          correctText : tempListCompletes[entryIn.key].toString(),
        ));

      }
      );
    },
    );
  }

  void checkFinish() {
    // var sudokuGenerator = SudokuGenerator(emptySquares: 54);
    // List<List<List<int>>> completes = partition(sudokuGenerator.newSudokuSolved,
    // sqrt(sudokuGenerator.newSudoku.length).toInt()).toList();
    // partition(sudokuGenerator.newSudoku,
    // sqrt(sudokuGenerator.newSudoku.length).toInt()).toList()
    // .asMap()
    // .entries
    // .forEach((entry){
    //   List<int> tempListCompletes =
    //       completes[entry.key].expand((element) => element).toList();
    //   List<int> tempList = entry.value.expand((element) => element).toList();
    //
    //
    //   tempList.asMap().entries.forEach((entryIn){
    //     int index = entry.key * sqrt(sudokuGenerator.newSudoku.length).toInt() *
    //         (entryIn.key % 9 ).toInt() ~/ 3 ;
    //     if (boxInners.where((element) => element.index == index ).length == 0 ){
    //       boxInners.add(BoxInner(index , []));
    //
    //     }
    //     BoxInner boxInner = boxInners.where((element) => element.index == index).first;
    //     boxInner.blokChars.add(BlokChar(
    //       entryIn.value == 0 ? "" : entryIn.value.toString(),
    //       index: boxInner.blokChars.length,
    //       isDefault : entryIn.value != 0,
    //       isCorrect : entryIn.value != 0 ,
    //       correctText : tempListCompletes[entryIn.key].toString(),
    //     ));
    //
    //   }
    //   );
    // },
    // );
  }
}

class BlokChar{

  String? text ;
  String? correctText ;
  int? index ;
  bool isFocus = false ;
  bool isCorrect ;
  bool isDefault ;
  bool isExist = false ;

  BlokChar(this.text ,
      {this.index, this.isDefault = false, this.correctText, this.isCorrect = false
      });
get isCorrectPos => correctText == text;
setText(String text ){
  this.text = text;
  isCorrect = isCorrectPos;

}
 setEmpty(){

 text = "";
 isCorrect = false;
 }
}
class BoxInner{
  late int index;
  List<BlokChar> blokChars = new List<BlokChar>.from([]);

  BoxInner(this.index , this.blokChars);
  setFocus(int index , Direction direction){
    List<BlokChar> temp ;
    if(direction == Direction.Horizontal){

      temp = blokChars
          .where((element) => element.index! ~/3 == index ~/ 3).toList();
    }
    else{
      temp = blokChars
          .where((element) => element.index! % 3 == index % 3).toList();

    }
    temp.forEach((element) {
      element.isFocus = true;

    }
    );
  }
setExistValue(int index , int indexBox , String textInput , Direction direction ){
  List<BlokChar> temp ;

  if(direction == Direction.Horizontal){

    temp = blokChars
        .where((element) => element.index! ~/3 == index ~/ 3).toList();
  }
  else{
    temp = blokChars
        .where((element) => element.index! % 3 == index % 3).toList();

  }
  if(this.index == indexBox){

    List<BlokChar> blokCharsBox = blokChars.where((element) => element.text == textInput).toList();
    if (blokCharsBox.length == 1 &&  temp.isEmpty) blokCharsBox.clear();
    temp.addAll(blokCharsBox);
  }
  temp.where((element) => element.text == textInput).forEach((element) {
    element.isExist = true ;
  });
}
clearFocus (){
  blokChars.forEach((element) {element.isExist = false;
  })  ;

}
  clearExist (){
    blokChars.forEach((element) {element.isFocus = false;
    })  ;

  }
}
enum Direction{
  Horizontal , Vertical

}
class FocusClass{
  int? indexBox ;
  int? indexChar ;
  setData(int indexBox , int indexChar)
  {
    this.indexBox = indexBox;
    this.indexChar = indexChar;
  }
  focusOn(int indexBox , int indexChar){
    return this.indexBox == indexBox && this.indexChar == indexChar ;


  }
}