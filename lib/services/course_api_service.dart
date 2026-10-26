// Made Wilasih - 2415051088

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';
import 'course_data_source.dart'; // <-- TAMBAHKAN INI

class CourseApiService implements CourseDataSource {
  // <-- UBAH JADI IMPLEMENTS
  CourseApiService(this.baseUrl);

  final String baseUrl;

  @override // <-- TAMBAHKAN INI
  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course. HTTP ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => Course.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override // <-- TAMBAHKAN INI
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      return Course.fromJson(data);
    }

    throw Exception(
      'Gagal membuat course. HTTP ${response.statusCode}: ${response.body}',
    );
  }

  @override // <-- TAMBAHKAN INI
  Future<void> updateCourse(int id, Course course) async {
    final bodyJson = jsonEncode(course.toJson());

    print('DATA YANG DIKIRIM KE SERVER: $bodyJson');

    final response = await http.put(
      Uri.parse('$baseUrl/courses/$id'),
      headers: {'Content-Type': 'application/json'},
      body: bodyJson,
    );

    print('STATUS CODE DARI SERVER: ${response.statusCode}');
    print('RESPON DARI SERVER: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal memperbarui course');
    }
  }

  @override // <-- TAMBAHKAN INI
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/courses/$id'));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal menghapus course');
    }
  }
}
