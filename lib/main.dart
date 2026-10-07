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

Widget buildCourseCard(BuildContext context, Map<String, dynamic> course) {
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
    child: InkWell(
      borderRadius: BorderRadius.circular(10),

      // TAP: membuka halaman detail
      onTap: () async {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
        );

        if (result == true && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Course berhasil ditambahkan ke favorite'),
            ),
          );
        }
      },

      // LONG PRESS: menampilkan informasi
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${course['title']} • ${course['code']} • ${course['credits']} SKS',
            ),
          ),
        );
      },

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

            // FAVORITE BUTTON
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Favorite dapat diubah dari halaman Detail'),
                  ),
                );
              },
              icon: const Icon(Icons.favorite_border, color: Colors.red),
              tooltip: 'Favorite',
            ),
          ],
        ),
      ),
    ),
  );
}

int columnsFor(double width) {
  if (width < 600) return 1;
  if (width < 840) return 2;
  return 3;
}

class CourseGrid extends StatelessWidget {
  final List<dynamic> courses;

  const CourseGrid({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnsFor(constraints.maxWidth),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index] as Map<String, dynamic>;

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFFD5DFE8)),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),

                // TAP
                onTap: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseDetailPage(course: course),
                    ),
                  );

                  if (result == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Course berhasil ditambahkan ke favorite',
                        ),
                      ),
                    );
                  }
                },

                // LONG PRESS
                onLongPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${course['title']} • ${course['code']} • ${course['credits']} SKS',
                      ),
                    ),
                  );
                },

                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
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

                      const SizedBox(height: 4),

                      // FAVORITE ICON
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12),
      color: Colors.blue.shade50,
      child: const Text('Compact Layout\n2415051088 - Made Wilasih'),
    );
  }
}

class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(12),
      color: Colors.green.shade50,
      child: const Text('Medium Layout\n2415051088 - Made Wilasih'),
    );
  }
}

class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(12),
      color: Colors.orange.shade50,
      child: const Text('Expanded Layout\n2415051088 - Made Wilasih'),
    );
  }
}

// TAHAP 4 - EXPANDED, FLEXIBLE, DAN WRAP

Widget buildBox(String text) {
  return Container(
    height: 80,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.blue),
    ),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

class LayoutPractice extends StatelessWidget {
  const LayoutPractice({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = [
      'Flutter',
      'Dart',
      'UI Design',
      'Git',
      'GitHub',
      'Responsive',
    ];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tahap 4 - Expanded, Flexible, dan Wrap',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text('$studentId - $studentName'),

          const SizedBox(height: 10),

          // Expanded 2 : 1
          Row(
            children: [
              Expanded(flex: 2, child: buildBox('Panel A - Flex 2')),
              const SizedBox(width: 8),
              Expanded(child: buildBox('Panel B - Flex 1')),
            ],
          ),

          const SizedBox(height: 14),

          const Text('Skills:', style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 6),

          // Wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) => Chip(label: Text(skill))).toList(),
          ),
        ],
      ),
    );
  }
}
// TAHAP 6 - SINGLECHILDSCROLLVIEW DAN KEYBOARD
// TAHAP 16 - KASUS A: RENDERFLEX OVERFLOW

class DebugCaseAPage extends StatefulWidget {
  const DebugCaseAPage({super.key});

  @override
  State<DebugCaseAPage> createState() => _DebugCaseAPageState();
}

class _DebugCaseAPageState extends State<DebugCaseAPage> {
  final TextEditingController commentController = TextEditingController();

  bool isNavigating = false;

  final items = List.generate(10, (index) => 'Data materi ${index + 1}');

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  // KASUS D
  void openDetail() {
    // Mencegah tombol ditekan berkali-kali
    if (isNavigating) return;

    setState(() {
      isNavigating = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DebugDetailPage()),
    ).then((_) {
      if (mounted) {
        setState(() {
          isNavigating = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 16 - Debugging')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IDENTITAS
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // =========================
            // KASUS A
            // =========================
            const Text(
              'Kasus A - RenderFlex Overflow',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.info),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    '$studentId - $studentName - '
                    'teks sangat panjang untuk menguji '
                    'RenderFlex overflow pada Row.',
                    softWrap: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              'Solusi: Expanded membuat teks menggunakan '
              'ruang yang tersedia sehingga tidak overflow.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // =========================
            // KASUS B
            // =========================
            const Text(
              'Kasus B - Unbounded Height',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'ListView diperbaiki dengan batas tinggi '
              'menggunakan SizedBox.',
              style: TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: 180,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    child: ListTile(
                      leading: const Icon(Icons.menu_book, color: Colors.blue),
                      title: Text(items[index]),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Solusi: ListView diberi batas tinggi sehingga '
              'tidak mendapatkan tinggi tak terbatas.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // =========================
            // KASUS C
            // =========================
            const Text(
              'Kasus C - Keyboard Overflow',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Form dibuat scrollable agar tetap dapat '
              'diakses ketika keyboard muncul.',
              style: TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                hintText: 'Ketik komentar...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Input berhasil diterima')),
                  );
                },
                child: const Text('Kirim'),
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // KASUS D
            // =========================
            const Text(
              'Kasus D - Navigasi Ganda',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tombol dicegah melakukan push berulang '
              'ketika proses navigasi sedang berlangsung.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isNavigating ? null : openDetail,
                child: Text(
                  isNavigating ? 'Membuka...' : 'Buka Halaman Detail',
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Identitas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            const Text('$studentId - $studentName'),
          ],
        ),
      ),
    );
  }
}

// HALAMAN DETAIL UNTUK KASUS D

class DebugDetailPage extends StatelessWidget {
  const DebugDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text('Halaman Detail berhasil dibuka.'),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tahap 6 - Scrollable Content dan Keyboard',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text('$studentId - $studentName'),

          const SizedBox(height: 16),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: 'NIM',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Program Studi',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Semester',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Alamat',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Keterangan',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Simpan'),
            ),
          ),

          const SizedBox(height: 300),
        ],
      ),
    );
  }
}

// TAHAP 7 - NAVIGATOR PUSH DAN POP

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DetailPage()),
                );
              },
              child: const Text('Buka Detail'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text('Ini adalah halaman Detail.'),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$studentId - $studentName',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              widget.course['title'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text('Code: ${widget.course['code']}'),
            Text('Credits: ${widget.course['credits']} SKS'),
            Text('Status: ${widget.course['status']}'),

            const SizedBox(height: 20),

            // LOCAL STATE - FAVORITE
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              child: Text(
                isFavorite ? '❤️ Sudah Favorite' : '♡ Pilih/Favorite',
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
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
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();

    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
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
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          return const CompactLayout();
                        } else if (constraints.maxWidth < 840) {
                          return const MediumLayout();
                        } else {
                          return const ExpandedLayout();
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$studentId - $studentName'),
                          Text('Width: ${size.width.toStringAsFixed(0)}'),
                          Text('Height: ${size.height.toStringAsFixed(0)}'),
                          Text('Orientation: $orientation'),
                          Text(size.width < 600 ? 'Compact' : 'Wide'),
                        ],
                      ),
                    ),
                    const LayoutPractice(),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Course Grid',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    CourseGrid(courses: courses),
                    const ProfileForm(),
                    const SizedBox(height: 10),
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

                    // TAHAP 1 - CONTAINER HARD-CODED
                    Container(
                      width: 500,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      color: Colors.orange.shade100,
                      child: Text(
                        '$studentId - $studentName',
                        style: const TextStyle(fontSize: 14),
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

                      return buildCourseCard(context, course);
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

// TAHAP 11 - ADAPTIVE NAVIGATION

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<Widget> pages = const [HomeTab(), CoursesTab(), ProfileTab()];

  Widget buildNavigationBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Widget buildNavigationRail() {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
        NavigationRailDestination(
          icon: Icon(Icons.school),
          label: Text('Courses'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // COMPACT / MEDIUM
        if (constraints.maxWidth < 840) {
          return Scaffold(
            body: pages[selectedIndex],
            bottomNavigationBar: buildNavigationBar(),
          );
        }

        // EXPANDED
        return Scaffold(
          body: Row(
            children: [
              buildNavigationRail(),
              const VerticalDivider(width: 1),
              Expanded(child: pages[selectedIndex]),
            ],
          ),
        );
      },
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Learning Dashboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('$studentId - $studentName'),
          ],
        ),
      ),
    );
  }
}

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  late Future<Map<String, dynamic>> courseFuture;
  bool favorites = false;
  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  @override
  void initState() {
    super.initState();

    courseFuture = loadStudentData();

    searchController.addListener(() {
      setState(() {
        searchText = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        title: const Text(
          'Course Explorer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: courseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat course: ${snapshot.error}'),
            );
          }

          final data = snapshot.data!;
          final courses = data['courses'] as List<dynamic>;

          final filteredCourses = courses.where((courseData) {
            final course = courseData as Map<String, dynamic>;

            final title = (course['title'] as String).toLowerCase();
            final code = (course['code'] as String).toLowerCase();

            return title.contains(searchText) || code.contains(searchText);
          }).toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              final isExpanded = constraints.maxWidth >= 840;

              return Column(
                children: [
                  // IDENTITAS
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$studentId - $studentName',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF183A5A),
                        ),
                      ),
                    ),
                  ),

                  // SEARCH
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search courses...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchText.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFEAF2F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // TAHAP 2 - SHARED STATE DARI PARENT KE DUA CHILD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CourseFavoriteStatus(
                          favorites: favorites,
                          onToggle: () {
                            setState(() {
                              favorites = !favorites;
                            });
                          },
                        ),

                        const SizedBox(height: 8),

                        CourseFavoriteButton(
                          favorites: favorites,
                          onToggle: () {
                            setState(() {
                              favorites = !favorites;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  // JUMLAH COURSE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${filteredCourses.length} course tersedia',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // COURSE LIST / GRID
                  Expanded(
                    child: filteredCourses.isEmpty
                        ? const Center(
                            child: Text(
                              'Course tidak ditemukan',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isExpanded ? 2 : 1,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: isExpanded ? 2.8 : 3.2,
                                ),
                            itemCount: filteredCourses.length,
                            itemBuilder: (context, index) {
                              final course =
                                  filteredCourses[index]
                                      as Map<String, dynamic>;

                              final status = course['status'] as String;

                              String statusText;
                              Color statusColor;

                              if (status == 'done') {
                                statusText = 'Completed';
                                statusColor = Colors.green;
                              } else if (status == 'active') {
                                statusText = 'Active';
                                statusColor = Colors.teal;
                              } else {
                                statusText = 'Planned';
                                statusColor = Colors.orange;
                              }

                              return Card(
                                elevation: 0,
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Color(0xFFD0DCE6),
                                  ),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),

                                  // TAP COURSE
                                  onTap: () async {
                                    final result = await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            CourseDetailPage(course: course),
                                      ),
                                    );

                                    if (result == true && context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Course berhasil ditambahkan ke favorite',
                                              ),
                                            ),
                                          );
                                    }
                                  },

                                  // LONG PRESS
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text(
                                            course['title'] as String,
                                          ),
                                          content: Text(
                                            'Code: ${course['code']}\n'
                                            'Credits: ${course['credits']} SKS\n'
                                            'Status: $statusText',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Tutup'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },

                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      children: [
                                        // ICON
                                        Container(
                                          width: 46,
                                          height: 46,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.school,
                                            color: Colors.blue,
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        // COURSE INFO
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                course['title'] as String,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF183A5A),
                                                ),
                                              ),

                                              const SizedBox(height: 5),

                                              Text(
                                                '${course['code']} • ${course['credits']} SKS',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              ),

                                              const SizedBox(height: 5),

                                              Text(
                                                statusText,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: statusColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // FAVORITE
                                        IconButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${course['title']} dipilih sebagai favorite',
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.favorite_border,
                                            color: Colors.red,
                                          ), // TAHAP 16 - KASUS A: RENDERFLEX OVERFLOW
                                          tooltip: 'Favorite',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class CourseFavoriteStatus extends StatelessWidget {
  final bool favorites;
  final VoidCallback onToggle;

  const CourseFavoriteStatus({
    super.key,
    required this.favorites,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          favorites ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        const SizedBox(width: 6),
        Text(favorites ? 'Favorite aktif' : 'Belum favorite'),
        IconButton(onPressed: onToggle, icon: const Icon(Icons.refresh)),
      ],
    );
  }
}

class CourseFavoriteButton extends StatelessWidget {
  final bool favorites;
  final VoidCallback onToggle;

  const CourseFavoriteButton({
    super.key,
    required this.favorites,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onToggle,
      child: Text(favorites ? 'Hapus Favorite' : 'Tambah Favorite'),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: studentName);
  final nimController = TextEditingController(text: studentId);
  final commentController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    commentController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah kamu yakin ingin mengirim feedback?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Mengirim...'),
            ],
          ),
        );
      },
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feedback berhasil dikirim oleh ${nameController.text}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tahap 13 - Form Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: nimController,
              decoration: const InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'NIM wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                hintText: 'Masukkan komentar minimal 5 karakter',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Komentar wajib diisi';
                }

                if (value.trim().length < 5) {
                  return 'Komentar minimal 5 karakter';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitForm,
                child: const Text('Kirim Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),

            const SizedBox(height: 16),

            const Text(
              studentName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              studentId,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 6),

            const Text('Pendidikan Teknik Informatika'),

            const SizedBox(height: 20),

            const Divider(),

            const FeedbackForm(),

            const SizedBox(height: 20),
          ],
        ),
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

      home: const MainNavigation(),
    );
  }
}
