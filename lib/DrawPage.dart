import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yourday/Selectionpage.dart';

void main() => runApp(DrawPage());

class DrawPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingPage(),
    );
  }
}

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<DrawnLine> _lines = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 4.0;
  bool isEraserSelected = false;
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text('Draw'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            var selectedDay = DateTime.now();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectionPage(selectedDay: selectedDay),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Controls Container
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                buildColorSelector(),
                buildStrokeSlider(),
              ],
            ),
          ),
          // Drawing Area
          Expanded(
            child: RepaintBoundary(
              key: _globalKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox renderBox =
                            _globalKey.currentContext!.findRenderObject()
                                as RenderBox;
                        Offset localPosition =
                            renderBox.globalToLocal(details.globalPosition);

                        // Ensure the drawing point is within drawing area boundaries
                        if (localPosition.dy >= 0 &&
                            localPosition.dy <= constraints.maxHeight &&
                            localPosition.dx >= 0 &&
                            localPosition.dx <= constraints.maxWidth) {
                          _lines.add(
                            DrawnLine(
                              localPosition,
                              selectedColor,
                              strokeWidth,
                            ),
                          );
                        }
                      });
                    },
                    onPanEnd: (details) {
                      _lines.add(DrawnLine(null, selectedColor, strokeWidth)); // Adds a break between strokes
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(_lines),
                      size: Size.infinite,
                    ),
                  );
                },
              ),
            ),
          ),
          // Save Button Positioned at Bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveToFile,
              child: Text(
                'SAVE',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColorSelector() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildColorButton(Colors.black),
          buildColorButton(Colors.red),
          buildColorButton(Colors.green),
          buildColorButton(Colors.blue),
          buildColorButton(Colors.yellow),
          buildEraserButton(),
          buildClearButton(),
        ],
      ),
    );
  }

  Widget buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEraserSelected = false;
          selectedColor = color;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color ? Colors.grey : Colors.white,
            width: 3.0,
          ),
        ),
      ),
    );
  }

  Widget buildEraserButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEraserSelected = true;
          selectedColor = Colors.white;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isEraserSelected ? Colors.grey : Colors.black,
            width: 3.0,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.cleaning_services,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget buildClearButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _lines.clear();
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 3.0,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.clear,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget buildStrokeSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Stroke Width: "),
        Slider(
          value: strokeWidth,
          min: 1.0,
          max: 20.0,
          divisions: 19,
          label: strokeWidth.round().toString(),
          onChanged: (value) {
            setState(() {
              strokeWidth = value;
            });
          },
        ),
      ],
    );
  }

  Future<void> _saveToFile() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = (await getApplicationDocumentsDirectory()).path;
      final filePath =
          '$directory/drawing_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved to $filePath')),
      );
    } catch (e) {
      print('Error saving file: $e');
    }
  }
}

class DrawnLine {
  final Offset? point;
  final Color color;
  final double strokeWidth;

  DrawnLine(this.point, this.color, this.strokeWidth);
}

class DrawingPainter extends CustomPainter {
  final List<DrawnLine> lines;

  DrawingPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < lines.length - 1; i++) {
      if (lines[i].point != null && lines[i + 1].point != null) {
        Paint paint = Paint()
          ..color = lines[i].color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = lines[i].strokeWidth;
        canvas.drawLine(lines[i].point!, lines[i + 1].point!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
