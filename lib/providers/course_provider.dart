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

  Future<void> updateCourse(int id, Course course) async {
    if (isSaving) {
      throw StateError('Penyimpanan course sedang berlangsung.');
    }

    isSaving = true;
    notifyListeners();

    try {
      await repository.updateCourse(id, course);

      // Muat ulang daftar setelah pembaruan berhasil.
      await loadCourses();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> deleteCourse(int id) async {
    if (isSaving) {
      throw StateError('Proses sedang berlangsung.');
    }

    isSaving = true;
    notifyListeners();

    try {
      await repository.deleteCourse(id);

      // Hapus dari list lokal courses
      courses.removeWhere((course) => course.id == id);

      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menghapus course: $e');
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
