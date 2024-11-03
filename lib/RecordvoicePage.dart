import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'RecordingsListPage.dart';

class RecordVoicePage extends StatefulWidget {
  final DateTime selectedDay;
  RecordVoicePage({super.key, required this.selectedDay});

  @override
  _RecordVoicePageState createState() => _RecordVoicePageState();
}

class _RecordVoicePageState extends State<RecordVoicePage> {
  final _record = Record();
  bool _isRecording = false;
  List<Map<String, String>> _recordings = []; // To store recording details

  @override
  void dispose() {
    _record.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (await _record.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(":", "-");
      final path = '${directory.path}/voice_recording_$timestamp.m4a';

      await _record.start(
        path: path,
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );

      setState(() {
        _isRecording = true; // Update UI to show recording state
      });
    }
  }

  Future<void> _stopRecording() async {
    final path = await _record.stop();
    if (path != null) {
      setState(() {
        _isRecording = false; // Update UI to stop recording state
        // Add recording with default title as selected date
        _recordings.add({
          'title': DateFormat('dd-MM-yyyy').format(widget.selectedDay),
          'path': path,
        });
      });
    }
  }

  void _navigateToRecordingsList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordingsListPage(recordings: _recordings), // Pass _recordings here
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final formattedDate = DateFormat('dd-MM-yyyy').format(widget.selectedDay);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(108, 10, 193, 1),
      ),
      backgroundColor: const Color.fromARGB(221, 218, 187, 243),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "LET’S LISTEN TO WHAT YOU HAVE TODAY!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromRGBO(108, 10, 193, 1),
                  fontFamily: 'Gagalin-Regular',
                  fontSize: 32,
                ),
              ),
            ),
          ),
          Container(
            height: screenSize.height * 0.06,
            width: screenSize.width * 0.5,
            child: Center(
              child: Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'PlayfairDisplay',
                  color: Color.fromRGBO(82, 12, 143, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromRGBO(194, 143, 239, 1),
            ),
          ),
          const SizedBox(height: 5),
          Image.asset(
            'assets/Voicerecord.png',
            height: screenSize.height * 0.5,
            width: screenSize.width * 0.6,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                color: const Color.fromRGBO(160, 78, 231, 1),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    if (_isRecording) {
                      _stopRecording();
                    } else {
                      _startRecording();
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: _navigateToRecordingsList,
              child: const Text(
                "Show Recordings",
                style: TextStyle(
                  fontFamily: 'Gagalin-Regular',
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Color.fromRGBO(108, 10, 193, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
