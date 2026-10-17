import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 70),
          Text(
            'Made Wilasih',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text('NIM: 2415051088'),
          Text('Pendidikan Teknik Informatika'),
        ],
      ),
    );
  }
}
