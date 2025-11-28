import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/scan_result.dart';
import 'diagnostic_result_screen.dart';

class ScanLoadingScreen extends StatefulWidget {
  final String imagePath;
  final String plantType;

  const ScanLoadingScreen({
    super.key,
    required this.imagePath,
    required this.plantType,
  });

  @override
  State<ScanLoadingScreen> createState() => _ScanLoadingScreenState();
}

class _ScanLoadingScreenState extends State<ScanLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _simulateAnalysis();
  }

  Future<void> _simulateAnalysis() async {
    // Simulate server processing time
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      // Generate mock result
      final result = ScanResult.getMockResult(
        widget.plantType,
        widget.imagePath,
      );

      // Navigate to results
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DiagnosticResultScreen(result: result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Loading Indicator
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Title
                const Text(
                  'Analyse en cours...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 16),

                // Plant Type
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.eco, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        widget.plantType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  'Notre IA analyse votre plante pour détecter\nd\'éventuelles maladies ou problèmes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
