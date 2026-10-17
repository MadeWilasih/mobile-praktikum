import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();

    return FutureBuilder<List<Course>>(
      future: state.getCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Gagal memuat course.'));
        }

        final courses = (snapshot.data ?? [])
            .where((course) => state.isFavorite(course.code))
            .toList();

        if (courses.isEmpty) {
          return const Center(child: Text('Belum ada course favorite.'));
        }

        return ListView(
          children: courses.map((course) {
            return ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: Text(course.title),
              subtitle: Text(course.code),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => state.toggleFavorite(course.code),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
