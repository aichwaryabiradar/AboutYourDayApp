import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RecordingsListPage extends StatefulWidget {
  @override
  _RecordingsListPageState createState() => _RecordingsListPageState();
}

class _RecordingsListPageState extends State<RecordingsListPage> {
  final _audioPlayer = AudioPlayer();
  List<FileSystemEntity> _recordings = [];
  Directory? _recordingsDirectory;

  @override
  void initState() {
    super.initState();
    _initializeDirectory();
  }

  Future<void> _initializeDirectory() async {
    // Get the app's documents directory
    final directory = await getApplicationDocumentsDirectory();
    _recordingsDirectory = Directory('${directory.path}/Recordings');

    // Ensure the directory exists
    if (!await _recordingsDirectory!.exists()) {
      await _recordingsDirectory!.create(recursive: true);
    }

    _loadRecordings();
  }

  void _loadRecordings() {
    setState(() {
      _recordings = _recordingsDirectory!.listSync();
    });
  }

  Future<void> _playRecording(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
  }

  Future<void> _renameRecording(File file) async {
    TextEditingController renameController = TextEditingController(
      text: file.path.split('/').last,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rename Recording"),
          content: TextField(
            controller: renameController,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final newPath =
                    '${file.parent.path}/${renameController.text}.m4a';
                await file.rename(newPath);
                Navigator.of(context).pop();
                _loadRecordings(); // Refresh the list after renaming
              },
              child: const Text("Rename"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recordings"),
        backgroundColor: const Color.fromRGBO(108, 10, 193, 1),
      ),
      body: _recordings.isNotEmpty
          ? ListView.builder(
              itemCount: _recordings.length,
              itemBuilder: (context, index) {
                final file = _recordings[index] as File;
                final fileName = file.path.split('/').last;
                return ListTile(
                  title: Text(fileName),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _renameRecording(file),
                  ),
                  onTap: () => _playRecording(file.path),
                );
              },
            )
          : const Center(
              child: Text("No recordings available"),
            ),
    );
  }
}
