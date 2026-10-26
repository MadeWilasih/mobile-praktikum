// Made Wilasih - 2415051088

import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  final CourseApiService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }

  Future<Course> createCourse(Course course) {
    return service.createCourse(course);
  }

  // Tambahan untuk update course pada Tahap 7
  Future<void> updateCourse(int id, Course course) {
    return service.updateCourse(id, course);
  }
}
