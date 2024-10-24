import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DisplayImagePage extends StatefulWidget {
  const DisplayImagePage({Key? key, required File image}) : super(key: key);

  @override
  State<DisplayImagePage> createState() => _DisplayImagePageState();
}

class _DisplayImagePageState extends State<DisplayImagePage> {
  final List<File> _images = []; // List to store selected images

  // Method to pick an image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _images.add(File(pickedFile.path)); // Add image to the list
    });
  }

  // Method to pick an image from camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    setState(() {
      _images.add(File(pickedFile.path)); // Add image to the list
    });
  }

  // Show options to pick image from gallery or camera
  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height / 4,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Pick from Gallery"),
                onTap: () {
                  Navigator.of(context).pop(); // Close the modal
                  _pickImageFromGallery(); // Pick image from gallery
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Capture from Camera"),
                onTap: () {
                  Navigator.of(context).pop(); // Close the modal
                  _pickImageFromCamera(); // Pick image from camera
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Selected Images"),
        backgroundColor: const Color.fromRGBO(125, 218, 219, 1),
      ),
      backgroundColor: const Color.fromRGBO(206, 248, 249, 1),
      body: _images.isEmpty
          ? const Center(child: Text("No images selected."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: FileImage(_images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Positioned(
        top: 10,
        right: 10,
        child: FloatingActionButton(
          onPressed: () {
            _showImagePickerOptions(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
