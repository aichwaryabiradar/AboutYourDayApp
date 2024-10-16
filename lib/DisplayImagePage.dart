import 'package:flutter/material.dart';
import 'dart:io';

class DisplayImagePage extends StatelessWidget {
  final File image; // The image file passed from the previous screen

  const DisplayImagePage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Selected Image"),
        backgroundColor: const Color.fromRGBO(125, 218, 219, 1),
      ),
      backgroundColor: const Color.fromRGBO(206, 248, 249, 1),
      body: Center(
        child: Image.file(
          image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
