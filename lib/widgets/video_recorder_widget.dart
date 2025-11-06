import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../controllers/onboarding_controller.dart';

class VideoRecorderWidget extends ConsumerStatefulWidget {
  const VideoRecorderWidget({super.key});

  @override
  ConsumerState<VideoRecorderWidget> createState() =>
      _VideoRecorderWidgetState();
}

class _VideoRecorderWidgetState extends ConsumerState<VideoRecorderWidget> {
  CameraController? _controller;
  VideoPlayerController? _videoPlayerController;
  bool _init = false;
  bool _isPlaying = false;
  DateTime? _recordingStartTime;
  Duration _recordingDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: true,
      );
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _init = true);
    } catch (e) {
      debugPrint('Camera setup error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _controller!.startVideoRecording();
      _recordingStartTime = DateTime.now();
      ref.read(onboardingControllerProvider.notifier).setVideoRecording(true);
      _updateRecordingDuration();
    } catch (e) {
      debugPrint('Error starting video recording: $e');
    }
  }

  void _updateRecordingDuration() {
    if (!mounted) return;
    if (_recordingStartTime != null) {
      setState(() {
        _recordingDuration = DateTime.now().difference(_recordingStartTime!);
      });
      Future.delayed(const Duration(seconds: 1), _updateRecordingDuration);
    }
  }

  Future<void> _stop() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;
    try {
      final xFile = await _controller!.stopVideoRecording();
      _recordingStartTime = null;
      if (xFile == null || xFile.path.isEmpty) {
        ref
            .read(onboardingControllerProvider.notifier)
            .setVideoRecording(false);
        return;
      }
      final file = File(xFile.path);
      if (await file.exists()) {
        ref
            .read(onboardingControllerProvider.notifier)
            .setVideoResult(file, _recordingDuration);
        _recordingDuration = Duration.zero;
      } else {
        ref
            .read(onboardingControllerProvider.notifier)
            .setVideoRecording(false);
      }
    } catch (e) {
      debugPrint('Error stopping video recording: $e');
      ref.read(onboardingControllerProvider.notifier).setVideoRecording(false);
    }
  }

  Future<void> _playVideo(File file) async {
    try {
      if (_videoPlayerController != null) {
        await _videoPlayerController!.dispose();
      }
      _videoPlayerController = VideoPlayerController.file(file);
      await _videoPlayerController!.initialize();
      _videoPlayerController!.addListener(_videoListener);
      await _videoPlayerController!.play();
      if (mounted) {
        setState(() => _isPlaying = true);
      }
    } catch (e) {
      debugPrint('Error playing video: $e');
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  void _videoListener() {
    if (!mounted || _videoPlayerController == null) return;
    final wasPlaying = _isPlaying;
    final isNowPlaying = _videoPlayerController!.value.isPlaying;
    if (wasPlaying != isNowPlaying) {
      setState(() => _isPlaying = isNowPlaying);
    }
  }

  Future<void> _pauseVideo() async {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isPlaying) {
      await _videoPlayerController!.pause();
      setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final recording = state.isVideoRecording;
    final hasVideo = state.recordedVideoFile != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recording &&
            _init &&
            _controller != null &&
            _controller!.value.isRecordingVideo) ...[
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: Stack(
              children: [
                CameraPreview(_controller!),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _RecordingIndicator(),
                        const SizedBox(width: 8),
                        Text(
                          _formatDuration(_recordingDuration),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _stop,
                icon: const Icon(Icons.stop),
                label: const Text('Stop'),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () async {
                  try {
                    if (_controller != null &&
                        _controller!.value.isRecordingVideo) {
                      await _controller!.stopVideoRecording();
                    }
                    _recordingStartTime = null;
                    _recordingDuration = Duration.zero;
                  } catch (e) {
                    debugPrint('Error canceling video: $e');
                  }
                  ref
                      .read(onboardingControllerProvider.notifier)
                      .setVideoRecording(false);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ] else if (!_init) ...[
          const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
        ] else if (hasVideo) ...[
          Container(
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
                    const Icon(Icons.videocam),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Video recorded')),
                    IconButton(
                      onPressed: () {
                        if (_isPlaying) {
                          _pauseVideo();
                        } else {
                          _playVideo(state.recordedVideoFile!);
                        }
                      },
                      icon: Icon(
                        _isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _videoPlayerController?.dispose();
                        _videoPlayerController = null;
                        ref
                            .read(onboardingControllerProvider.notifier)
                            .deleteVideo();
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
                if (_videoPlayerController != null &&
                    _videoPlayerController!.value.isInitialized) ...[
                  const SizedBox(height: 8),
                  AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController!),
                  ),
                ],
              ],
            ),
          ),
        ] else ...[
          ElevatedButton.icon(
            onPressed: _start,
            icon: const Icon(Icons.videocam),
            label: const Text('Record Video'),
          ),
        ],
      ],
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _RecordingIndicator extends StatefulWidget {
  const _RecordingIndicator();
  @override
  State<_RecordingIndicator> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<_RecordingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FadeTransition(
          opacity: _controller,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Text('REC'),
      ],
    );
  }
}
