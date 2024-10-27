import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, required File videoFile});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  final List<File> _videoFiles = []; // List to store selected video files
  final List<VideoPlayerController> _controllers = []; // List of video controllers
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo(ImageSource source) async {
    final pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile != null) {
      final File videoFile = File(pickedFile.path);
      _videoFiles.add(videoFile); // Add video to the list
      _initializeVideoController(videoFile); // Initialize the video controller
    }
  }

  void _initializeVideoController(File videoFile) {
    final VideoPlayerController controller = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {}); // Refresh the UI when the video is ready
      });
    _controllers.add(controller); // Add the controller to the list
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selected Videos"),
        backgroundColor: const Color.fromRGBO(240, 27, 103, 1),
      ),
      body: _videoFiles.isNotEmpty
          ? ListView.builder(
              itemCount: _videoFiles.length,
              itemBuilder: (context, index) {
                if (index < _controllers.length) { // Check controller exists for index
                  final VideoPlayerController controller = _controllers[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          )
                        : const CircularProgressIndicator(),
                  );
                } else {
                  return const SizedBox.shrink(); // Placeholder if controller is not ready
                }
              },
            )
          : const Center(
              child: Text("No videos selected"),
            ),
      floatingActionButton: Stack(
        children: [
          // FloatingActionButton for picking video from gallery
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () => _pickVideo(ImageSource.gallery),
              tooltip: 'Pick Video from Gallery',
              heroTag: 'gallery',
              child: const Icon(Icons.video_library),
            ),
          ),
          // FloatingActionButton for recording video from camera
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () => _pickVideo(ImageSource.camera),
                tooltip: 'Record Video from Camera',
                heroTag: 'camera',
                child: const Icon(Icons.videocam),
              ),
            ),
          ),
          // FloatingActionButton for adding more videos
          Padding(
            padding: const EdgeInsets.only(bottom: 160.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.video_library),
                          title: const Text('Pick Video from Gallery'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickVideo(ImageSource.gallery);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.videocam),
                          title: const Text('Record Video from Camera'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickVideo(ImageSource.camera);
                          },
                        ),
                      ],
                    ),
                  );
                },
                tooltip: 'Add Video',
                heroTag: 'add',
                backgroundColor: Colors.green,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
