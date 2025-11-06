import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/experience_selection_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/curved_progress_bar.dart';
import '../../widgets/experience_card.dart';
import '../../widgets/next_button_animated.dart';
import '../experience_details/experience_details_view.dart';

class ExperienceSelectionView extends ConsumerWidget {
  const ExperienceSelectionView({super.key});

  static const String routeName = '/experience-selection';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(experienceSelectionControllerProvider);
    final notifier = ref.read(experienceSelectionControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟩 Custom header with progress bar
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const Expanded(
                    child: CurvedProgressBar(
                      progress: 0.13,
                    ), 
                  ),
                  IconButton(
                    onPressed:
                        () => Navigator.of(context).popUntil((r) => r.isFirst),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Choose the types of experiences you want to host',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: state.experiences.when(
                  data: (items) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;
                        final crossAxisCount = isWide ? 3 : 2;
                        return AnimatedListView(
                          itemsLength: items.length,
                          builder: (context, index) {
                            final item = items[index];
                            final selected = state.selectedIds.contains(
                              item.id,
                            );
                            return AnimatedPadding(
                              duration: const Duration(milliseconds: 250),
                              padding: EdgeInsets.only(top: selected ? 0 : 8),
                              child: GridTile(
                                child: ExperienceCard(
                                  experience: item,
                                  isSelected: selected,
                                  onTap:
                                      () => notifier.toggleSelection(item.id),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.3,
                              ),
                        );
                      },
                    );
                  },
                  error: (e, _) => Center(child: Text('Failed to load: $e')),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: NextButtonAnimated(
                      expanded: true,
                      onPressed: () {
                        debugPrint(
                          'Selected IDs: ${state.selectedIds.toList()}',
                        );
                        debugPrint('Description: ${state.description}');
                        Navigator.of(
                          context,
                        ).pushNamed(ExperienceDetailsView.routeName);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedListView extends StatelessWidget {
  const AnimatedListView({
    super.key,
    required this.itemsLength,
    required this.builder,
    required this.gridDelegate,
  });
  final int itemsLength;
  final IndexedWidgetBuilder builder;
  final SliverGridDelegate gridDelegate;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: gridDelegate,
      itemCount: itemsLength,
      itemBuilder: builder,
    );
  }
}
