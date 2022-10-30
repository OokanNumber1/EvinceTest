import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:evince_test/model/audio.dart';
import 'package:evince_test/services/network_service.dart';
import 'package:evince_test/services/player_service.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({required this.audio, super.key});
  final Audio audio;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final audioService = AudioService(AudioPlayer());

  final networkService = NetworkService(Dio());
  double downloadProgress = 0;

  @override
  void initState() {
    super.initState();
    audioService.setAudio(widget.audio.url);

    audioService.audioPlayer.onPlayerStateChanged.listen((state) =>
        setState(() => audioService.isPlaying = state == PlayerState.playing));

    audioService.audioPlayer.onDurationChanged.listen(
        (newDuration) => setState(() => audioService.duration = newDuration));

    audioService.audioPlayer.onPositionChanged.listen(
        (newPosition) => setState(() => audioService.position = newPosition));
  }

  @override
  void dispose() {
    audioService.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.audio.title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              Text(
                widget.audio.description,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Icon(Icons.music_note, size: 32),
              const SizedBox(height: 24),
              Slider(
                min: 0,
                max: audioService.duration.inSeconds.toDouble(),
                value: audioService.position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioService.audioPlayer.seek(position);
                  await audioService.audioPlayer.resume();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(audioService.formatTime(audioService.position)),
                  Text(audioService.formatTime(
                      audioService.duration - audioService.position)),
                ],
              ),
              const SizedBox(height: 24),
              audioService.duration == Duration.zero
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async => audioService.isPlaying
                              ? await audioService.audioPlayer.pause()
                              : await audioService.audioPlayer.resume(),
                          icon: Icon(
                            audioService.isPlaying
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            size: 48,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final title = widget.audio.title.split(" ")[0];
                            networkService.downloadAudio(
                              widget.audio.url,
                              title,
                              (count, total) {
                                if (total != -1) {
                                  setState(() {
                                    downloadProgress = (count / total) * 100;
                                  });
                                }
                              },
                            );
                          },
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.download_for_offline,
                              size: 48,
                            ),
                          ),
                        )
                      ],
                    ),
              const SizedBox(height: 24),
              downloadProgress == 0
                  ? const SizedBox()
                  : downloadProgress == 100.0
                      ? const Icon(Icons.done_outline_sharp)
                      : LinearProgressIndicator(
                          backgroundColor: Colors.grey[100],
                          color: Colors.brown[400],
                          value: downloadProgress / 100,
                        )
            ],
          ),
        ),
      ),
    );
  }
}
