import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class RecordVoicePage extends StatefulWidget {
  final DateTime selectedDay;
  const RecordVoicePage({super.key, required this.selectedDay});

  @override
  _RecordVoicePageState createState() => _RecordVoicePageState();
}

class _RecordVoicePageState extends State<RecordVoicePage> {
  final _record = Record(); // Instance of the Record class for recording
  final _audioPlayer = AudioPlayer(); // Instance of AudioPlayer for playback
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedFilePath;

  @override
  void dispose() {
    _record.dispose(); // Dispose the record object when the widget is disposed
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (await _record.hasPermission()) {
      final path = 'voice_recording.m4a'; // You can specify a custom path

      await _record.start(
        path: path,
        encoder: AudioEncoder.aacLc, // Use the correct encoder
        bitRate: 128000,
        samplingRate: 44100,
      );

      setState(() {
        _isRecording = true;
        _recordedFilePath = path; // Save the path to the recorded file
      });
    } else {
      // Handle the case where permissions are not granted
    }
  }

  Future<void> _stopRecording() async {
    await _record.stop();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _playRecording() async {
    if (_recordedFilePath != null) {
      await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
      setState(() {
        _isPlaying = true;
      });

      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          _isPlaying = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(
                  color: Color.fromRGBO(108, 10, 193, 1),
                  fontFamily: 'Gagalin-Regular',
                  fontSize: 32,
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            width: 300,
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
          Opacity(
            opacity: 0.4,
            child: Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/Voicerecord.png'),
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
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
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: _recordedFilePath != null && !_isPlaying ? _playRecording : null,
              child: Text(
                _isPlaying ? "Playing..." : "Play Recording",
                style: const TextStyle(
                  fontFamily: 'Gagalin-Regular',
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), backgroundColor: Color.fromRGBO(108, 10, 193, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 60,
              width: 100,
              child: Center(
                child: Text(
                  "SAVE",
                  style: TextStyle(
                    fontFamily: 'Gagalin-Regular',
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(108, 10, 193, 1),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
