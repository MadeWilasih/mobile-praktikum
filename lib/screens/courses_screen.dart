// Made Wilasih - 2415051088

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'course_detail_screen.dart';
import 'create_course_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    final Widget content;

    if (provider.isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (provider.error != null) {
      content = ErrorView(
        message: provider.error!,
        onRetry: provider.loadCourses,
      );
    } else if (provider.courses.isEmpty) {
      content = const Center(child: Text('Data course belum tersedia'));
    } else {
      final courses = provider.courses;

      content = ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];

          return CourseCard(
            course: course,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(course: course),
                ),
              );
            },
          );
        },
      );
    }

    // Bungkus dengan SafeArea agar otomatis turun di bawah status bar/kamera
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                8,
              ), // Diberi jarak atas & samping yang lebih pas
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Tambah Course'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateCourseScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}
