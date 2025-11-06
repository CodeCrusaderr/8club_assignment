import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingMediaState {
  final String motivationText;
  final File? recordedAudioFile;
  final Duration? recordedAudioDuration;
  final File? recordedVideoFile;
  final Duration? recordedVideoDuration;
  final bool isAudioRecording;
  final bool isVideoRecording;

  const OnboardingMediaState({
    required this.motivationText,
    required this.recordedAudioFile,
    required this.recordedAudioDuration,
    required this.recordedVideoFile,
    required this.recordedVideoDuration,
    required this.isAudioRecording,
    required this.isVideoRecording,
  });

  OnboardingMediaState copyWith({
    String? motivationText,
    File? recordedAudioFile,
    Duration? recordedAudioDuration,
    File? recordedVideoFile,
    Duration? recordedVideoDuration,
    bool? isAudioRecording,
    bool? isVideoRecording,
    bool clearAudio = false,
    bool clearVideo = false,
  }) {
    return OnboardingMediaState(
      motivationText: motivationText ?? this.motivationText,
      recordedAudioFile: clearAudio ? null : (recordedAudioFile ?? this.recordedAudioFile),
      recordedAudioDuration: clearAudio ? null : (recordedAudioDuration ?? this.recordedAudioDuration),
      recordedVideoFile: clearVideo ? null : (recordedVideoFile ?? this.recordedVideoFile),
      recordedVideoDuration: clearVideo ? null : (recordedVideoDuration ?? this.recordedVideoDuration),
      isAudioRecording: isAudioRecording ?? this.isAudioRecording,
      isVideoRecording: isVideoRecording ?? this.isVideoRecording,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingMediaState> {
  OnboardingController()
      : super(const OnboardingMediaState(
          motivationText: '',
          recordedAudioFile: null,
          recordedAudioDuration: null,
          recordedVideoFile: null,
          recordedVideoDuration: null,
          isAudioRecording: false,
          isVideoRecording: false,
        ));

  void updateMotivation(String value) {
    state = state.copyWith(motivationText: value);
  }

  void setAudioRecording(bool recording) {
    state = state.copyWith(isAudioRecording: recording);
  }

  void setVideoRecording(bool recording) {
    state = state.copyWith(isVideoRecording: recording);
  }

  void setAudioResult(File file, Duration duration) {
    state = state.copyWith(recordedAudioFile: file, recordedAudioDuration: duration, isAudioRecording: false);
  }

  void setVideoResult(File file, Duration duration) {
    state = state.copyWith(recordedVideoFile: file, recordedVideoDuration: duration, isVideoRecording: false);
  }

  void deleteAudio() {
    state.recordedAudioFile?.delete().catchError((_) {});
    state = state.copyWith(clearAudio: true);
  }

  void deleteVideo() {
    state.recordedVideoFile?.delete().catchError((_) {});
    state = state.copyWith(clearVideo: true);
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingMediaState>((ref) => OnboardingController());


