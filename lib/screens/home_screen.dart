import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Made Wilasih',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text('NIM: 2415051088'),
          SizedBox(height: 20),
          Text('Learning Dashboard'),
        ],
      ),
    );
  }
}
