import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yourday/VideoPlayerPage.dart';
import 'dart:io'; // For handling files
//import 'video_player_page.dart'; // Create this for displaying the video

class AddVideoPage extends StatelessWidget {
  const AddVideoPage({super.key});

  Future<void> _pickVideo(ImageSource source, BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(source: source);

    if (pickedFile != null) {
      // Navigate to the video player page and pass the picked video file
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(videoFile: File(pickedFile.path)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(240, 27, 103, 1),
      ),
      backgroundColor: const Color.fromRGBO(255, 210, 226, 1),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/video.png',
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
                    "Let's see the beautiful clip!", // Instruction text
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gagalin-Regular',
                      color: Color.fromRGBO(240, 27, 103, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 150, 20, 30),
                  child: ElevatedButton(
                    onPressed: () => _pickVideo(ImageSource.camera, context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 174, 201, 1),
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
                            color: Color.fromRGBO(240, 27, 103, 1),
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
                    onPressed: () => _pickVideo(ImageSource.gallery, context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 174, 201, 1),
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
                            color: Color.fromRGBO(240, 27, 103, 1),
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
