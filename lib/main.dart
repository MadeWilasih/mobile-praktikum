import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Made Wilasih';
const String studentId = '2415051088';

final List<Map<String, dynamic>> topics = [
  {'title': 'Git & GitHub', 'subtitle': 'Version control', 'done': true},
  {'title': 'Dart Fundamentals', 'subtitle': 'Language basics', 'done': true},
  {
    'title': 'Flutter UI Fundamentals',
    'subtitle': 'Widgets & layout',
    'done': false,
  },
  {
    'title': '$studentId - $studentName',
    'subtitle': 'Pemilik aplikasi',
    'done': false,
  },
];

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MyApp());
}

// SUMMARY CARD

Widget buildStatCard(String value, String label, IconData icon) {
  return Expanded(
    child: Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFFD5DFE8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

// COURSE CARD

Widget buildCourseCard(Map<String, dynamic> course) {
  final status = course['status'] as String;

  String statusText;
  Color statusColor;

  if (status == 'done') {
    statusText = 'Selesai';
    statusColor = Colors.green;
  } else if (status == 'active') {
    statusText = 'Berjalan';
    statusColor = Colors.orange;
  } else {
    statusText = 'Direncanakan';
    statusColor = Colors.grey;
  }

  return Card(
    elevation: 0,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Color(0xFFD5DFE8)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['title'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${course['code']} • ${course['credits']} SKS',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// GREETING CARD
class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();

  String message = 'Belum ada pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$studentId - $studentName'),
        TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Masukkan pesan'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              message = controller.text.trim().isEmpty
                  ? 'Input masih kosong'
                  : controller.text.trim();
            });
          },
          child: const Text('Tampilkan'),
        ),
        const SizedBox(height: 8),
        Text(message),
      ],
    );
  }
}

// DASHBOARD PAGE
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();

    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      body: Column(
        children: [
          // HEADER BIRU
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              height: 56,
              color: Colors.blue,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: const Text(
                'Learning Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // DATA DARI JSON
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: studentFuture,
              builder: (context, snapshot) {
                // LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ERROR
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Gagal memuat data: ${snapshot.error}'),
                  );
                }

                // DATA
                final data = snapshot.data!;

                final student = data['student'] as Map<String, dynamic>;

                final courses = data['courses'] as List<dynamic>;

                // TOTAL SKS
                final totalCredits = courses.fold<int>(
                  0,
                  (sum, course) => sum + (course['credits'] as int),
                );

                // JUMLAH YANG SELESAI
                final completedCourses = courses
                    .where((course) => course['status'] == 'done')
                    .length;

                // PROGRESS
                final progress = courses.isEmpty
                    ? 0
                    : ((completedCourses / courses.length) * 100).round();

                // MATA KULIAH YANG SEDANG BERJALAN
                Map<String, dynamic>? activeCourse;

                for (final course in courses) {
                  if (course['status'] == 'active') {
                    activeCourse = course as Map<String, dynamic>;
                    break;
                  }
                }

                return ListView(
                  padding: const EdgeInsets.only(bottom: 14),
                  children: [
                    // IDENTITAS
                    Card(
                      elevation: 0,
                      margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFFD0DCE6)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        child: Row(
                          children: [
                            // FOTO
                            const CircleAvatar(
                              radius: 31,
                              backgroundImage: AssetImage(
                                'assets/images/profile.jpg',
                              ),
                            ),

                            const SizedBox(width: 12),

                            // NAMA, NIM, SEMESTER
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    student['nim'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 2),

                                  Text(
                                    student['level'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // TOPIK YANG SEDANG DIPELAJARI
                    if (activeCourse != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.shade50,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.school,
                                color: Colors.blue,
                                size: 25,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activeCourse['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  const Text(
                                    'Pertemuan 4',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 5),

                    // SUMMARY
                    Row(
                      children: [
                        buildStatCard(
                          '${courses.length}',
                          'Topik',
                          Icons.menu_book,
                        ),

                        buildStatCard(
                          '$progress%',
                          'Progress',
                          Icons.trending_up,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // DAFTAR MATERI
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Daftar Materi',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF183A5A),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 3),

                    // LIST 5 TOPIK
                    ...courses.map((courseData) {
                      final course = courseData as Map<String, dynamic>;

                      return buildCourseCard(course);
                    }),

                    const SizedBox(height: 4),

                    // KETERANGAN
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Data list dimuat dari JSON statik',
                        style: TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// MY APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),

      home: const DashboardPage(),
    );
  }
}
