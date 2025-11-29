import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/scan_result.dart';
import '../../services/api_service.dart';
import 'diagnostic_result_screen.dart';

class ScanLoadingScreen extends StatefulWidget {
  final String imagePath;
  final String plantType; // English name for API
  final String? plantTypeDisplay; // French name for display
  final Map<String, dynamic>? environmentalData;

  const ScanLoadingScreen({
    super.key,
    required this.imagePath,
    required this.plantType,
    this.plantTypeDisplay,
    this.environmentalData,
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
    try {
      String prediction = 'Healthy';
      String? diseaseClass;
      double? confidence;

      // Call environmental health API if environmental data is provided
      if (widget.environmentalData != null) {
        try {
          final envResponse = await ApiService.predictEnvironmentalHealth(
            widget.environmentalData!,
          );
          prediction = envResponse['prediction'] ?? 'Healthy';
          print('DEBUG: Environmental prediction: $prediction');
        } catch (e) {
          print('DEBUG: Environmental API error: $e');
          // Continue with default prediction if API fails
        }
      }

      // Call plant disease API
      try {
        final diseaseResponse = await ApiService.predictPlantDisease(
          widget.plantType,
          widget.imagePath,
        );

        if (diseaseResponse['success'] == true) {
          final data = diseaseResponse['data'] as Map<String, dynamic>;
          final classId = data['predicted_class']?.toString();
          if (classId != null) {
            diseaseClass = classId;
          }
          confidence = (data['confidence'] as num?)?.toDouble();
          print(
            'DEBUG: Disease prediction: $diseaseClass (ID: $classId) with confidence: $confidence',
          );
        }
      } catch (e) {
        print('DEBUG: Plant disease API error: $e');
        // Show error to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'analyse: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      if (mounted) {
        // Generate result with API data
        final result = ScanResult.getMockResult(
          widget.plantTypeDisplay ?? widget.plantType,
          widget.imagePath,
          prediction: prediction,
          environmentalData: widget.environmentalData,
          diseaseClass: diseaseClass,
          confidence: confidence,
        );

        // Navigate to results
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DiagnosticResultScreen(result: result),
          ),
        );
      }
    } catch (e) {
      print('DEBUG: Analysis error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'analyse: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
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
                        widget.plantTypeDisplay ?? widget.plantType,
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
