import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_state.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();
    final favorite = state.isFavorite(course.code);

    return Card(
      child: ListTile(
        title: Text(course.title),
        subtitle: Text('${course.code} • ${course.credits} SKS'),
        trailing: IconButton(
          icon: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () => state.toggleFavorite(course.code),
        ),
        onTap: onTap,
      ),
    );
  }
}
