import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/experience.dart';

class ExperienceService {
  ExperienceService({Dio? dio}) : _dio = dio ?? Dio();

  static const String _baseUrl =
      'https://staging.chamberofsecrets.8club.co/v1/experiences?active=true';

  final Dio _dio;

  Future<List<Experience>> fetchActiveExperiences() async {
    try {
      final response = await _dio.get(_baseUrl);
      final data = response.data;
      
      if (data is Map<String, dynamic>) {
        final dataObj = data['data'];
        if (dataObj is Map<String, dynamic>) {
          final experiences = dataObj['experiences'];
          if (experiences is List) {
            return experiences
                .map((e) => Experience.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
        if (dataObj is List) {
          return dataObj
              .map((e) => Experience.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      if (data is List) {
        return data
            .map((e) => Experience.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching experiences: $e');
      rethrow;
    }
  }
}


