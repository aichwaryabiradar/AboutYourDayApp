import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: ui.Color.fromARGB(255, 244, 237, 184),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildColorPickerButton(),
                      buildEraserButton(),
                      buildUndoButton(),
                      buildClearButton(),
                    ],
                  ),
                  buildStrokeSlider(),
                ],
              ),
            ),
          ),

          // Drawing Area
          Expanded(
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                color: Colors.white, // Set canvas to pure white
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onPanUpdate: (details) {
                        RenderBox renderBox = _globalKey.currentContext!
                            .findRenderObject() as RenderBox;
                        Offset localPosition =
                            renderBox.globalToLocal(details.globalPosition);

                        // Constrain drawing to within the canvas
                        if (localPosition.dy >= 0 &&
                            localPosition.dy <= constraints.maxHeight &&
                            localPosition.dx >= 0 &&
                            localPosition.dx <= constraints.maxWidth) {
                          setState(() {
                            _lines.add(
                              DrawnLine(
                                localPosition,
                                isEraserSelected ? Colors.white : selectedColor,
                                strokeWidth,
                              ),
                            );
                          });
                        }
                      },
                      onPanEnd: (details) {
                        // Add null to separate line segments
                        _lines.add(DrawnLine(null, selectedColor, strokeWidth));
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
                backgroundColor: Colors.amberAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColorPickerButton() {
    return GestureDetector(
      onTap: _openColorPicker,
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isEraserSelected
                ? ui.Color.fromARGB(255, 0, 0, 0)
                : selectedColor,
            width: 3.0,
          ),
        ),
        child: Icon(
          Icons.color_lens,
          color: isEraserSelected
              ? const ui.Color.fromARGB(255, 0, 0, 0)
              : selectedColor,
          size: 24.0,
        ),
      ),
    );
  }

  Widget buildEraserButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEraserSelected = !isEraserSelected;
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
            Icons.cleaning_services, // Substitute for an eraser icon
            color: isEraserSelected ? Colors.grey : Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget buildUndoButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_lines.isNotEmpty) {
            _lines.removeLast(); // Removes the most recent change
          }
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
            Icons.undo,
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
          _lines.clear(); // Clears the entire canvas
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Stroke Width: "),
          Expanded(
            child: Slider(
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
          ),
        ],
      ),
    );
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Select'),
              onPressed: () {
                setState(() {
                  isEraserSelected =
                      false; // Reset eraser when a color is selected
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
