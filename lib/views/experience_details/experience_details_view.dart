import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/experience_details_controller.dart';
import '../../widgets/background_painter.dart';
import '../../widgets/curved_progress_bar.dart';
import '../../widgets/next_button_animated.dart';
import '../onboarding_question/onboarding_question_view.dart';

class ExperienceDetailsView extends ConsumerWidget {
  const ExperienceDetailsView({super.key});

  static const String routeName = '/experience-details';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(experienceDetailsControllerProvider.notifier);

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
                    const Expanded(child: CurvedProgressBar(progress: 0.56)),
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
                  // padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.76,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'What kind of hotspots do you want to host?',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 32),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/experience_selection.jpg',
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextField(
                            maxLength: 250,
                            maxLines: 5,
                            onChanged: notifier.updateDescription,
                            decoration: const InputDecoration(
                              hintText:
                                  'Describe the hotspots you plan to host (max 250 chars)',
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: NextButtonAnimated(
                        expanded: true,
                        onPressed:
                            () => Navigator.of(
                              context,
                            ).pushNamed(OnboardingQuestionView.routeName),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
