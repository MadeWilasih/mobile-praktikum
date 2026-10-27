// Made Wilasih - 2415051088

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart'; // <-- Pastikan mengimpor CourseProvider
import '../providers/course_state.dart';
import 'edit_course_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  // Fungsi untuk menampilkan AlertDialog konfirmasi hapus
  void _confirmAndDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus course ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), // Tutup dialog
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Tutup dialog konfirmasi

                try {
                  // Jalankan proses HTTP DELETE melalui CourseProvider
                  // Perhatikan: pastikan course.id tidak null (menggunakan course.id!)
                  await context.read<CourseProvider>().deleteCourse(course.id!);

                  // Periksa context.mounted sebelum menggunakan context setelah await
                  if (!context.mounted) return;

                  // Tampilkan SnackBar sukses
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course berhasil dihapus')),
                  );

                  // Kembali ke halaman sebelumnya (List Course)
                  Navigator.pop(context);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus: $e')),
                  );
                }
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();
    final favorite = state.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
        actions: [
          // Tombol Edit di AppBar (Sudah direvisi agar merefresh list setelah edit)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCourseScreen(course: course),
                ),
              );

              // Jika berhasil diperbarui, kembali ke halaman sebelumnya untuk refresh list
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          // Tambahan Tombol Delete (Ikon Sampah) di AppBar
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmAndDelete(context),
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
