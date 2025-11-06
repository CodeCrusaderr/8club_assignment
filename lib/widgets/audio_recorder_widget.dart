import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import '../controllers/onboarding_controller.dart';
import '../theme/app_theme.dart';

class AudioRecorderWidget extends ConsumerStatefulWidget {
  const AudioRecorderWidget({super.key});

  @override
  ConsumerState<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends ConsumerState<AudioRecorderWidget> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  StreamSubscription? _recorderSub;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  final List<double> _amplitudes = <double>[];
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _recorder.openRecorder();
    await _player.openPlayer();
    setState(() => _ready = true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorderSub?.cancel();
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  Future<String> _tempFilePath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
  }

  Future<void> _start() async {
    if (!_ready) return;
    ref.read(onboardingControllerProvider.notifier).setAudioRecording(true);
    _amplitudes.clear();
    _elapsed = Duration.zero;
    setState(() {}); 

    final path = await _tempFilePath();
    await _recorder.startRecorder(toFile: path, codec: Codec.aacADTS);
    
    // Start a timer to update the UI periodically
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final currentState = ref.read(onboardingControllerProvider);
      if (!mounted || !currentState.isAudioRecording) {
        timer.cancel();
        _timer = null;
        return;
      }
      if (mounted) {
        setState(() {
          _elapsed = _elapsed + const Duration(milliseconds: 100);
        });
      }
    });
    
    _recorderSub = _recorder.onProgress?.listen((e) {
      if (mounted) {
        setState(() {
          _elapsed = e.duration ?? _elapsed;
          _amplitudes.add(e.decibels != null ? ((e.decibels! + 60) / 60).clamp(0.0, 1.0) : 0.2);
          if (_amplitudes.length > 60) _amplitudes.removeAt(0);
        });
      }
    });
  }

  Future<void> _stop() async {
    try {
      _timer?.cancel();
      _timer = null;
      final filePath = await _recorder.stopRecorder();
      _recorderSub?.cancel();
      _recorderSub = null;
      if (filePath == null || filePath.isEmpty) {
        ref.read(onboardingControllerProvider.notifier).setAudioRecording(false);
        return;
      }
      ref.read(onboardingControllerProvider.notifier).setAudioResult(File(filePath), _elapsed);
    } catch (e) {
      _timer?.cancel();
      _timer = null;
      _recorderSub?.cancel();
      _recorderSub = null;
      ref.read(onboardingControllerProvider.notifier).setAudioRecording(false);
    }
  }

  Future<void> _play(File file) async {
    if (_player.isPlaying) {
      await _player.stopPlayer();
      setState(() {});
      return;
    }
    await _player.startPlayer(fromURI: file.path, codec: Codec.aacADTS, whenFinished: () => setState(() {}));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final recording = state.isAudioRecording;
    final hasAudio = state.recordedAudioFile != null;

    if (hasAudio && !recording) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.graphic_eq, color: AppColors.primaryAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Audio recorded (${_format(state.recordedAudioDuration ?? Duration.zero)})'),
                ),
                IconButton(
                  onPressed: () => _play(state.recordedAudioFile!),
                  icon: Icon(_player.isPlaying ? Icons.pause_circle : Icons.play_circle_fill),
                ),
                IconButton(
                  onPressed: () => ref.read(onboardingControllerProvider.notifier).deleteAudio(),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _WaveformBar(amplitudes: _amplitudes.isNotEmpty ? _amplitudes : List.filled(32, 0.3)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recording) ...[
          Row(
            children: [
              const _BlinkingDot(),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Recording audio...',
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _format(_elapsed),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _WaveformBar(amplitudes: _amplitudes),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  await _stop();
                },
                child: const Text('Stop'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () async {
                  try {
                    _timer?.cancel();
                    _timer = null;
                    await _recorder.stopRecorder();
                    _recorderSub?.cancel();
                    _recorderSub = null;
                  } catch (e) {
                    //
                  }
                  ref.read(onboardingControllerProvider.notifier).setAudioRecording(false);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ] else ...[
          ElevatedButton.icon(
            onPressed: _start,
            icon: const Icon(Icons.mic),
            label: const Text('Record Audio'),
          ),
        ],
      ],
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _WaveformBar extends StatelessWidget {
  const _WaveformBar({required this.amplitudes});
  final List<double> amplitudes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final amp in amplitudes)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  height: 8 + amp * 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [AppColors.secondaryAccent, AppColors.primaryAccent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BlinkingDot extends StatefulWidget {
  const _BlinkingDot();
  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(CurveTween(curve: Curves.easeInOut)),
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
      ),
    );
  }
}


