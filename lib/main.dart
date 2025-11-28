import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const BioScanDApp());
}

class BioScanDApp extends StatelessWidget {
  const BioScanDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BioScanD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
