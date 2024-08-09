import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AudioWaves extends StatefulWidget {
  final String path;
  const AudioWaves({super.key, required this.path});

  @override
  State<AudioWaves> createState() => _AudioWavesState();
}

class _AudioWavesState extends State<AudioWaves> {
  final PlayerController playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer(finishMode: FinishMode.stop);
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: playAndPause,
            icon: Icon(playerController.playerState.isPlaying
                ? CupertinoIcons.pause_solid
                : CupertinoIcons.play_arrow_solid)),
        Expanded(
          child: AudioFileWaveforms(
              size: const Size(double.infinity, 100),
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Pallete.borderColor,
                liveWaveColor: Pallete.gradient2,
                spacing: 6,
              ),
              playerController: playerController),
        ),
      ],
    );
  }
}
