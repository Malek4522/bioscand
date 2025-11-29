import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
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
