
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeGame extends StatefulWidget {


  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {

  static final int gridSize =20;
  static final int cellSize =25;
  List<int>snake =[45,65,85];
  int food =Random().nextInt(gridSize*gridSize);
  String direction ='right';
  int score =0;

  // Snake update codes
  void updateSnake(){
    setState(() {
      switch (direction){
        case 'up':
          if (snake.first<gridSize){
            snake.insert(0,snake.first-gridSize + gridSize * gridSize);
          }else{
            snake.insert(0,snake.first-gridSize);
          }
          break;
        case 'down':
          if (snake.first >= gridSize * gridSize - gridSize){
            snake.insert(0,snake.first % gridSize);
          }else{
            snake.insert(0,snake.first+ gridSize);
          }
          break;
        case "left":
          if (snake.first % gridSize== 0){
            snake.insert(0,snake.first + gridSize -1);
          }else{
            snake.insert(0,snake.first-1);
          }
          break;
        case "right":
          if ((snake.first + 1)% gridSize== 0){
            snake.insert(0,snake.first - gridSize +1);
          }else{
            snake.insert(0,snake.first+1);
          }
          break;

      }
      if (snake.first==food){
        score++;
        food =Random().nextInt(gridSize*gridSize);
      }else {
        snake.removeLast();
      }
    });

  }

  void onGameTick(Timer timer ){
    updateSnake();
    if (isGameOver()){
      timer.cancel();
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text ('Game Over'),
              content: Text('You lost! Score:$score'),
              actions: <Widget>[
                TextButton(
                  onPressed: (){
                    setState(() {
                      snake=[45,65,85];
                      food= Random().nextInt(gridSize*gridSize);
                      direction='right';
                      score=0;
                    });
                    Navigator.of(context).pop();
                    timer =Timer.periodic(Duration(microseconds: 200),
                        onGameTick);
                  },
                  child: Text('replay'),

                )
              ],
            );
          }
      );

    }
  }

  bool isGameOver(){
    int head =snake.first;
    if (snake.indexOf(head,1)!=-1){
      return true;
    } return false;
  }


  @override
  void initState(){
    Timer.periodic(Duration(milliseconds: 200),
        onGameTick);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Basic Snake tutorial game'
        ),
      ),
      body: Column(

        children: [
          Text(
            'Score:$score',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
              child:GestureDetector(

                onVerticalDragUpdate: (details){
                  if (direction!="up"&& details.delta.dy>0){
                    direction='down';
                  }else if (direction!="down" && details.delta.dy<0){
                    direction='up';
                  }
                },
                onHorizontalDragUpdate: (details){
                  if (direction!="left"&& details.delta.dx>0){
                    direction='right';
                  }else if (direction!="right" && details.delta.dx<0){
                    direction='left';
                  }
                },

                child: Container(
                    color:Colors.grey[800],
                    child: GridView.builder(
                        itemCount: gridSize*gridSize,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridSize,
                        ),
                        itemBuilder: (BuildContext context,int index){
                          if (snake.contains(index)){
                            return Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape:BoxShape.circle,
                              ),
                            );
                          }else if (index==food){
                            return Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape:BoxShape.circle,
                              ),
                            );
                          }else {
                            return Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape:BoxShape.circle,
                              ),
                            );
                          }

                        }

                    )
                ),



              )

          ),
          Padding(padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_up),
                      onPressed: (){
                        setState(() {
                          direction='up';
                        });
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left),
                      onPressed: (){
                        setState(() {
                          direction='left';
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: (){
                        setState(() {
                          direction='right';
                        });
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_down),
                      onPressed: (){
                        setState(() {
                          direction='down';
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),

        ],
      ),

    );
  }
}


