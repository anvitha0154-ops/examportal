import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ExamPrepPortal());
}

class ExamPrepPortal extends StatelessWidget {
  const ExamPrepPortal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Competitive Exam Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
