// Made Wilasih - 2415051088

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseService {
  static const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

  Future<List<Course>> loadCourses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      return data
          .map((item) => Course.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Gagal memuat courses. HTTP ${response.statusCode}');
  }
}
