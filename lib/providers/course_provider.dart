// Made Wilasih - 2415051088

import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Course> createCourse(Course course) async {
    if (isSaving) {
      throw StateError('Penyimpanan course sedang berlangsung.');
    }

    isSaving = true;
    notifyListeners();

    try {
      final createdCourse = await repository.createCourse(course);

      // Muat ulang daftar setelah pembuatan berhasil.
      await loadCourses();

      return createdCourse;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
