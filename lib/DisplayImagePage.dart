import 'package:flutter/material.dart';
import 'dart:io';

class DisplayImagePage extends StatelessWidget {
  final File image;

  const DisplayImagePage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Image'),
        backgroundColor: const Color.fromRGBO(125, 218, 219, 1),
      ),
      backgroundColor: const Color.fromRGBO(206, 248, 249, 1),
      body: Stack(
        children: [
          // Centered image container
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Positioned button at bottom right
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to AddImagePage for a new capture
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(125, 218, 219, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                "Add Image",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 6, 101, 118),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
