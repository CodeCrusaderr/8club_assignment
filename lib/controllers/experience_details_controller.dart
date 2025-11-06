import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExperienceDetailsState {
  final String description;
  const ExperienceDetailsState({required this.description});

  ExperienceDetailsState copyWith({String? description}) =>
      ExperienceDetailsState(description: description ?? this.description);
}

class ExperienceDetailsController extends StateNotifier<ExperienceDetailsState> {
  ExperienceDetailsController() : super(const ExperienceDetailsState(description: ''));

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }
}

final experienceDetailsControllerProvider =
    StateNotifierProvider<ExperienceDetailsController, ExperienceDetailsState>((ref) {
  return ExperienceDetailsController();
});


