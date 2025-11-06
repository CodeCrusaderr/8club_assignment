import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/app_theme.dart';
import 'views/experience_selection/experience_selection_view.dart';
import 'views/experience_details/experience_details_view.dart';
import 'views/onboarding_question/onboarding_question_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: HotspotHostsApp()));
}

class HotspotHostsApp extends StatelessWidget {
  const HotspotHostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotspot Hosts',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildThemeData(),
      initialRoute: ExperienceSelectionView.routeName,
      routes: {
        ExperienceSelectionView.routeName:
            (_) => const ExperienceSelectionView(),
        ExperienceDetailsView.routeName: (_) => const ExperienceDetailsView(),
        OnboardingQuestionView.routeName: (_) => const OnboardingQuestionView(),
      },
    );
  }
}
