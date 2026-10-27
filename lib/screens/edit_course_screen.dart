// Made Wilasih - 2415051088

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;

  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeController;
  late TextEditingController _titleController;
  late TextEditingController _creditsController;
  late String _status;

  @override
  void initState() {
    super.initState(); // Diperbaiki dari super.init()
    _codeController = TextEditingController(text: widget.course.code);
    _titleController = TextEditingController(text: widget.course.title);
    _creditsController = TextEditingController(
      text: widget.course.credits.toString(),
    );
    _status = widget.course.status;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submitEdit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedCourse = Course(
      id: widget.course.id,
      code: _codeController.text,
      title: _titleController.text,
      credits: int.parse(_creditsController.text),
      status: _status,
    );

    try {
      await context.read<CourseProvider>().updateCourse(
        widget.course.id!,
        updatedCourse,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course berhasil diperbarui')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memperbarui: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Kode Course (Read-Only)',
                  filled: true,
                  fillColor: Colors.black12,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Course'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'SKS (Credits)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'SKS tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'SKS harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue:
                    _status, // Mengganti parameter value yang deprecated
                items: ['planned', 'active', 'done'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: provider.isSaving ? null : _submitEdit,
                child: provider.isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
