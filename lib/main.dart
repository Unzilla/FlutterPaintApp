import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MaterialApp(home: PaintExample()));
}

class PaintExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PaintState();
    throw UnimplementedError();
  }
}

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({this.point, this.areaPaint});
}

class PaintState extends State<PaintExample> {
  var gesture;
  Color selectedColor;
  double strokeWidth;
  List <DrawingArea> pointst = [];

  // Color _colorCustom=new Color(0XFFcc2b5e);

  @override
  void initState() {
    // TODO: implement initState
    selectedColor = Colors.black; //init state to give default values
    strokeWidth = 2.0;
    super.initState();
  }

  void selectColor() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Color choser"),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (Color value) {
                  setState(() {
                    selectedColor = value;
                  });
                },

              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery
        .of(context)
        .size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Paint",
      home: Scaffold(
        appBar: AppBar(title: Text("Paint"),

        ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [new Color(0XFFcc2b5e), new Color(0XFF753a88)])

                )
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.80,
                      height: size.height * 0.70,

                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [ BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                              offset: Offset.zero
                          )
                          ]


                      ),
                      child: GestureDetector(
                        onPanDown: (details) {
                          this.setState(() {
                            pointst.add(DrawingArea(
                                point: details.localPosition,
                                areaPaint: Paint()
                                  ..strokeCap = StrokeCap.round
                                  ..isAntiAlias = true
                                  ..color = selectedColor
                                  ..strokeWidth = strokeWidth));
                          });
                        },
                        onPanUpdate: (details) {
                          this.setState(() {
                            pointst.add(DrawingArea(
                                point: details.localPosition,
                                areaPaint: Paint()
                                  ..strokeCap = StrokeCap.round
                                  ..isAntiAlias = true
                                  ..color = selectedColor
                                  ..strokeWidth = strokeWidth));
                          });
                          // _colorCustom=Colors.green;
                          // gesture=details;
                        },
                        onPanEnd: (details) {
                          this.setState(() {
                            pointst.add(null);
                          }
                          );
                        },


                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CustomPaint(
                            painter: MyCustomPaint(points: pointst),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: size.width * 0.80,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.color_lens),
                            color: selectedColor,
                            onPressed: () {
                              selectColor();
                            },
                          ),
                          Expanded(
                            child: Slider(
                              min: 1,
                              max: 7,
                              activeColor: selectedColor,
                              value: strokeWidth,
                              onChanged: (double value) {
                                this.setState(() {
                                  strokeWidth = value;
                                });
                              },

                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.layers), onPressed: () {
                            this.setState(() {
                              pointst.clear();
                            });
                          },
                          )
                        ],
                      ),

                    ),
                    Text("Gesture detected:${gesture}")
                  ],
                ),
              ),
            )


          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}

class MyCustomPaint extends CustomPainter {
  List<DrawingArea> points;

  MyCustomPaint({this.points});


  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint back = Paint()
      ..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, back);
    Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2.0;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
            points[i].point, points[i + 1].point, points[i].areaPaint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(
            PointMode.points, [ points[i].point], points[i].areaPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
    throw UnimplementedError();
  }


}
