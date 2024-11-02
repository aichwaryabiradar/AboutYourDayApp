import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

import 'dart:io';

import 'package:yourday/RecordingsListPage.dart';



class RecordVoicePage extends StatefulWidget {
  final DateTime selectedDay;
   RecordVoicePage({super.key, required this.selectedDay});

  @override
  
  _RecordVoicePageState createState() => _RecordVoicePageState();
}

class _RecordVoicePageState extends State<RecordVoicePage> {
  final _record = Record();
  final _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  String? _recordedFilePath;

  @override
  void dispose() {
    _record.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (await _record.hasPermission()) {
      final timestamp = DateTime.now().toIso8601String().replaceAll(":", "-");
      final path = '/storage/emulated/0/Recordings/voice_recording_$timestamp.m4a';

      await _record.start(
        path: path,
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );

      setState(() {
        _isRecording = true;
        _recordedFilePath = path;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _record.stop();
    setState(() {
      _isRecording = false;
    });
  }

  void _navigateToRecordingsList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordingsListPage(), // Navigate to the recordings list page
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
            height: screenSize.height*0.06,
            width: screenSize.width*0.5,
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
          const SizedBox(height: 5), // Spacer between date container and image
        Image.asset(
          'assets/Voicerecord.png',
          height: screenSize.height * 0.5,  // Adjust the height as needed
          width: screenSize.width * 0.6,  // Adjust the width as needed
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
