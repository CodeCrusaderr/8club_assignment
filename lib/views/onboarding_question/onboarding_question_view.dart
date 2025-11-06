import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/onboarding_controller.dart';
import '../../widgets/background_painter.dart';
import '../../widgets/curved_progress_bar.dart';
import '../../widgets/audio_recorder_widget.dart';
import '../../widgets/video_recorder_widget.dart';
import '../../widgets/next_button_animated.dart';

class OnboardingQuestionView extends ConsumerWidget {
  const OnboardingQuestionView({super.key});

  static const String routeName = '/onboarding-question';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    final mediaButtonsVisible =
        state.recordedAudioFile == null || state.recordedVideoFile == null;

    return Scaffold(
      body: SafeArea(
        child: SlantedCurvesBackground(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    const Expanded(child: CurvedProgressBar(progress: 1.0)),
                    IconButton(
                      onPressed:
                          () =>
                              Navigator.of(context).popUntil((r) => r.isFirst),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        'Why do you want to host with us?',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        'Tell us about your intent and what motivates you to create experiences.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        maxLength: 600,
                        maxLines: 8,
                        onChanged: notifier.updateMotivation,
                        decoration: const InputDecoration(
                          hintText: 'Share your motivation (max 600 chars)',
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (state.recordedAudioFile != null)
                        const AudioRecorderWidget(),
                      if (state.recordedVideoFile != null) ...[
                        const SizedBox(height: 12),
                        const VideoRecorderWidget(),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child:
                    mediaButtonsVisible
                        ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (state.recordedAudioFile == null)
                                    const AudioRecorderWidget(),
                                  if (state.recordedAudioFile == null &&
                                      state.recordedVideoFile == null)
                                    const SizedBox(height: 8),
                                  if (state.recordedVideoFile == null)
                                    const VideoRecorderWidget(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 160,
                              child: ElevatedButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.arrow_forward_rounded),
                                label: const Text('Next'),
                              ),
                            ),
                          ],
                        )
                        : NextButtonAnimated(
                          expanded: true,
                          animate: true,
                          onPressed: () {
                            debugPrint('Motivation: ${state.motivationText}');
                            debugPrint(
                              'Audio: ${state.recordedAudioFile?.path}',
                            );
                            debugPrint(
                              'Video: ${state.recordedVideoFile?.path}',
                            );
                            Navigator.of(context).popUntil((r) => r.isFirst);
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
