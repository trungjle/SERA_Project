import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:sera_app/models/entry.dart';
import 'package:sera_app/providers/entry_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum AudioState { start, recording, stop, play }
List<String> emotions = ["angry", "sad", "neutral", "happy"];

const veryDarkBlue = Color(0xff172133);
const kindaDarkBlue = Color(0xff202641);

class RecordSpeech extends StatefulWidget {
  final Entry entry;

  RecordSpeech({required this.entry, audioPlayer, path});
  @override
  _RecordSpeechState createState() => _RecordSpeechState();
}

class _RecordSpeechState extends State<RecordSpeech> {
  AudioState audioState = AudioState.start;
  late AudioPlayer _audioPlayer;
  late String path;

  void handleAudioState(AudioState state) {
    setState(() {
      // ignore: unnecessary_null_comparison
      if (audioState == AudioState.start) {
        // Starts recording
        audioState = AudioState.recording;
        _start();
      } else if (audioState == AudioState.recording) {
        audioState = AudioState.play;
        _stop();
        // Play recorded audio
      } else if (audioState == AudioState.play) {
        audioState = AudioState.stop;
        _audioPlayer = AudioPlayer();
        _audioPlayer.setUrl(path).then((_) {
          _audioPlayer.play().then((_) {
            setState(() => audioState = AudioState.play);
          });
        });

        // Stop recorded audio
      } else if (audioState == AudioState.stop) {
        audioState = AudioState.play;
        _audioPlayer.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<EntryProvider>(context);
    return Scaffold(
      backgroundColor: veryDarkBlue,
      appBar: AppBar(),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: handleAudioColour(),
              ),
              child: RawMaterialButton(
                fillColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(30),
                onPressed: () => handleAudioState(audioState),
                child: getIcon(audioState),
              ),
            ),
            SizedBox(width: 20),
            if (audioState == AudioState.play || audioState == AudioState.stop)
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kindaDarkBlue,
                ),
                child: RawMaterialButton(
                  fillColor: Colors.white,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(30),
                  onPressed: () => setState(() {
                    audioState = AudioState.start;
                  }),
                  child: Icon(Icons.replay, size: 50),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton:
          !(audioState == AudioState.play || audioState == AudioState.stop)
              ? Container()
              : FloatingActionButton(
                  child: Icon(Icons.emoji_emotions),
                  onPressed: () {
                    _sendAudio(path, entryProvider);
                  },
                ),
    );
  }

  Color handleAudioColour() {
    if (audioState == AudioState.recording) {
      return Colors.deepOrangeAccent.shade700.withOpacity(0.5);
    } else if (audioState == AudioState.stop) {
      return Colors.green.shade900;
    } else {
      return kindaDarkBlue;
    }
  }

  Icon getIcon(AudioState state) {
    switch (state) {
      case AudioState.play:
        return Icon(Icons.play_arrow, size: 50);
      case AudioState.stop:
        return Icon(Icons.stop, size: 50);
      case AudioState.recording:
        return Icon(Icons.mic, color: Colors.redAccent, size: 50);
      default:
        return Icon(Icons.mic, size: 50);
    }
  }

  Future<String> getPath() async {
    final dir = await getApplicationDocumentsDirectory();
    path = dir.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.m4a';

    return path;
  }

  Future<void> _start() async {
    await getPath().then((value) => {path = value});
    try {
      if (await Record.hasPermission()) {
        await Record.start(path: path);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    await Record.stop();
  }
}

Future<void> _sendAudio(String path, EntryProvider entryProvider) async {
  String url = "http://10.0.2.2:5000/predict";
  http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(
    await http.MultipartFile.fromPath(
      'file',
      File(path).path,
      contentType: MediaType('audio', 'm4a'),
    ),
  );
  http.StreamedResponse r = await request.send();
  if (r.statusCode == 200) {
    String value = await r.stream.transform(utf8.decoder).join();
    if (emotions.contains(value)) entryProvider.changeEmotion = value;
  }
}
