// Made Wilasih - 2415051088

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_state.dart';
import 'edit_course_screen.dart'; // <-- Pastikan import halaman edit

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();
    final favorite = state.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
        actions: [
          // Tambahan tombol edit di AppBar
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCourseScreen(course: course),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Made Wilasih - 2415051088',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              course.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('Code: ${course.code}'),
            Text('Credits: ${course.credits} SKS'),
            Text('Status: ${course.status}'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => state.toggleFavorite(course.code),
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              label: Text(
                favorite ? 'Hapus dari Favorite' : 'Tambah ke Favorite',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
