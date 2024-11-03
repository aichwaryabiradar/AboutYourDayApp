import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class RecordingsListPage extends StatefulWidget {
  final List<Map<String, String>> recordings;
  const RecordingsListPage({super.key, required this.recordings});

  @override
  _RecordingsListPageState createState() => _RecordingsListPageState();
}

class _RecordingsListPageState extends State<RecordingsListPage> {
  final _audioPlayer = AudioPlayer();
  String? _playingFilePath;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playRecording(String path) async {
    if (_playingFilePath != null && _playingFilePath == path) {
      await _audioPlayer.stop();
      setState(() {
        _playingFilePath = null;
      });
    } else {
      await _audioPlayer.play(DeviceFileSource(path));
      setState(() {
        _playingFilePath = path;
      });
    }
  }

  void _renameRecording(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String newTitle = widget.recordings[index]['title']!;
        return AlertDialog(
          title: Text('Rename Recording'),
          content: TextField(
            onChanged: (value) => newTitle = value,
            controller: TextEditingController(text: newTitle),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.recordings[index]['title'] = newTitle;
                });
                Navigator.of(context).pop();
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recordings'),
        backgroundColor: const Color.fromRGBO(108, 10, 193, 1),
      ),
      backgroundColor: const Color.fromARGB(221, 218, 187, 243),
      body: ListView.builder(
        itemCount: widget.recordings.length,
        itemBuilder: (context, index) {
          final recording = widget.recordings[index];
          return ListTile(
            title: Text(recording['title']!),
            subtitle: Text(recording['path']!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _playingFilePath == recording['path']
                        ? Icons.stop
                        : Icons.play_arrow,
                  ),
                  onPressed: () => _playRecording(recording['path']!),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _renameRecording(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
