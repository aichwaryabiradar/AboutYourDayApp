import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yourday/DisplayImagePage.dart';
import 'dart:io';

class AddImagePage extends StatefulWidget {
  const AddImagePage({super.key});

  @override
  _AddImagePageState createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      _navigateToDisplayPage(image);
    }
  }

  // Function to capture an image from the camera
  Future<void> _captureImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      _navigateToDisplayPage(image);
    }
  }

  // Function to navigate to the DisplayImagePage
  void _navigateToDisplayPage(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayImagePage(image: image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(125, 218, 219, 1),
      ),
      backgroundColor: const Color.fromRGBO(206, 248, 249, 1),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/camera.png',
                width: 300,
                height: 300,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    "Let's see the beautiful pictures!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gagalin-Regular',
                      color: Color.fromARGB(255, 6, 101, 118),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 150, 20, 30),
                  child: ElevatedButton(
                    onPressed: _captureImageFromCamera,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(125, 218, 219, 1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      width: 450,
                      height: 70,
                      child: const Center(
                        child: Text(
                          "Capture from Camera",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'BrittanySignature',
                            color: Color.fromARGB(255, 6, 101, 118),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                  child: ElevatedButton(
                    onPressed: _pickImageFromGallery,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(125, 218, 219, 1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      width: 450,
                      height: 70,
                      child: const Center(
                        child: Text(
                          "Add from Gallery",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'BrittanySignature',
                            color: Color.fromARGB(255, 6, 101, 118),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
