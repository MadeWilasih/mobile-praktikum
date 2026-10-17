import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_state.dart';
import '../widgets/course_card.dart';
import '../widgets/loading_widget.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();

    return FutureBuilder<List<Course>>(
      future: state.getCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Gagal memuat course.'));
        }
        final courses = snapshot.data ?? [];

        if (courses.isEmpty) {
          return const Center(child: Text('Belum ada course.'));
        }

        return ListView.builder(
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
      },
    );
  }
}
