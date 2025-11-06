import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/experience.dart';
import '../services/experience_service.dart';

class ExperienceSelectionState {
  final AsyncValue<List<Experience>> experiences;
  final Set<String> selectedIds;
  final String description;

  const ExperienceSelectionState({
    required this.experiences,
    required this.selectedIds,
    required this.description,
  });

  ExperienceSelectionState copyWith({
    AsyncValue<List<Experience>>? experiences,
    Set<String>? selectedIds,
    String? description,
  }) {
    return ExperienceSelectionState(
      experiences: experiences ?? this.experiences,
      selectedIds: selectedIds ?? this.selectedIds,
      description: description ?? this.description,
    );
  }
}

class ExperienceSelectionController extends StateNotifier<ExperienceSelectionState> {
  ExperienceSelectionController(this._service)
      : super(const ExperienceSelectionState(
          experiences: AsyncValue.loading(),
          selectedIds: {},
          description: '',
        )) {
    load();
  }

  final ExperienceService _service;

  Future<void> load() async {
    state = state.copyWith(experiences: const AsyncValue.loading());
    try {
      final items = await _service.fetchActiveExperiences();
      state = state.copyWith(experiences: AsyncValue.data(items));
    } catch (e, st) {
      state = state.copyWith(experiences: AsyncValue.error(e, st));
    }
  }

  void toggleSelection(String id) {
    final updated = Set<String>.from(state.selectedIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = state.copyWith(selectedIds: updated);
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }
}

final experienceServiceProvider = Provider<ExperienceService>((ref) {
  return ExperienceService();
});

final experienceSelectionControllerProvider =
    StateNotifierProvider<ExperienceSelectionController, ExperienceSelectionState>((ref) {
  final service = ref.watch(experienceServiceProvider);
  return ExperienceSelectionController(service);
});


