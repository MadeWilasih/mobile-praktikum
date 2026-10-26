import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

// Dibuat oleh: Made Wilasih - 2415051088
class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase.from('courses').select().order('id');

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  //status
  @override
  Future<Course> createCourse(Course course) async {
    // Mengirim data baru ke tabel 'courses' di Supabase
    final data = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(data);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    // Memperbarui data berdasarkan id
    await supabase.from('courses').update(course.toJson()).eq('id', id);
  }

  @override
  Future<void> deleteCourse(int id) async {
    // Menghapus data berdasarkan id
    await supabase.from('courses').delete().eq('id', id);
  }
}
