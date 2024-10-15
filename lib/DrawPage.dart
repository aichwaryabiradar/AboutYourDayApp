import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart'; // For file storage
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
  final GlobalKey _globalKey = GlobalKey(); // Key for RepaintBoundary

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
            ); // Navigate back
          },
        ),
      ),
      body: Column(
        children: [
          buildColorSelector(),
          buildStrokeSlider(),
          Expanded(
            child: RepaintBoundary( // Wrap the canvas in RepaintBoundary
              key: _globalKey,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    _lines.add(
                      DrawnLine(
                        renderBox.globalToLocal(details.globalPosition),
                        selectedColor,
                        strokeWidth,
                      ),
                    );
                  });
                },
                onPanEnd: (details) {
                  _lines.add(DrawnLine(null, selectedColor, strokeWidth)); // Adds a break between strokes
                },
                child: CustomPaint(
                  painter: DrawingPainter(_lines),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColorSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildColorButton(Colors.black),
          buildColorButton(Colors.red),
          buildColorButton(Colors.green),
          buildColorButton(Colors.blue),
          buildColorButton(Colors.yellow),
          buildEraserButton(),
          buildClearButton(), // Clear button
          buildSaveButton(),  // Save button next to the Clear button
        ],
      ),
    );
  }

  Widget buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEraserSelected = false; // Disable eraser when selecting a color
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
          selectedColor = Colors.white; // Eraser will paint in white
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: Colors.white, // Eraser is shown as white
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
          _lines.clear(); // Clears the drawing
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
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

  // Save button to save the drawing
  Widget buildSaveButton() {
    return GestureDetector(
      onTap: _saveToFile, // Call the save function when tapped
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 3.0,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.save,
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

  // Function to save the canvas as an image file
  Future<void> _saveToFile() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = (await getApplicationDocumentsDirectory()).path;
      final filePath = '$directory/drawing_${DateTime.now().millisecondsSinceEpoch}.png';
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
    return true; // Always repaint when lines change
  }
}
