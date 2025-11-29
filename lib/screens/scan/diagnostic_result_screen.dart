import 'package:flutter/material.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../../constants/colors.dart';
import '../../models/scan_result.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../home_screen.dart';
import '../scanner_screen.dart';
import '../history_screen.dart';

class DiagnosticResultScreen extends StatefulWidget {
  final ScanResult result;

  const DiagnosticResultScreen({super.key, required this.result});

  @override
  State<DiagnosticResultScreen> createState() => _DiagnosticResultScreenState();
}

class _DiagnosticResultScreenState extends State<DiagnosticResultScreen> {
  int _currentIndex = 1;

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else if (index == 1) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const ScannerScreen(),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HistoryScreen()),
      );
    }
  }

  Future<void> _handleShare() async {
    print('Attempting to share...');
    print('Image path: ${widget.result.imagePath}');

    final file = File(widget.result.imagePath);
    final exists = await file.exists();
    print('File exists: $exists');

    if (!exists) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur: L\'image n\'existe pas'),
            backgroundColor: AppColors.redIcon,
          ),
        );
      }
      return;
    }

    try {
      final StringBuffer sb = StringBuffer();
      sb.writeln('🌿 Résultat du Diagnostic BioScanD');
      sb.writeln('📅 Date: ${_formatDate(widget.result.timestamp)}');
      sb.writeln('🌱 Plante: ${widget.result.plantName}');
      sb.writeln(
        '📊 Confiance IA: ${(widget.result.confidence * 100).toInt()}%',
      );

      if (widget.result.diseaseName != null) {
        sb.writeln('\n⚠️ Maladie Détectée: ${widget.result.diseaseName}');
        if (widget.result.diseaseScientificName != null) {
          sb.writeln(
            '🔬 Nom scientifique: ${widget.result.diseaseScientificName}',
          );
        }
        if (widget.result.severity != null) {
          sb.writeln('🔴 Sévérité: ${widget.result.severity}');
        }
      }

      if (widget.result.recommendations.isNotEmpty) {
        sb.writeln('\n💡 Recommandations:');
        for (int i = 0; i < widget.result.recommendations.length; i++) {
          sb.writeln('${i + 1}. ${widget.result.recommendations[i]}');
        }
      }

      if (widget.result.treatmentPlan != null) {
        sb.writeln('\n💊 Plan de Traitement:');
        sb.writeln(widget.result.treatmentPlan);
      }

      sb.writeln('\n🔍 Analysé avec BioScanD');

      print('Calling Share.shareXFiles...');
      await Share.shareXFiles(
        [XFile(widget.result.imagePath)],
        text: sb.toString(),
        subject: 'Diagnostic BioScanD - ${widget.result.plantName}',
      );
      print('Share completed successfully');
    } catch (e, stack) {
      print('Error sharing: $e');
      print('Stack trace: $stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du partage: ${e.toString()}'),
            backgroundColor: AppColors.redIcon,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day;
    final month = date.month;
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    final monthNames = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];

    return '$day ${monthNames[month - 1]} $year à $hour:$minute';
  }

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Résultat enregistré avec succès!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Color _getSeverityColor(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'faible':
        return AppColors.greenIcon;
      case 'modérée':
      case 'moderee':
        return const Color(0xFFFFA726);
      case 'critique':
        return AppColors.redIcon;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(widget.result.timestamp);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Résultat du Diagnostic',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scanned Image Card
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(widget.result.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image,
                        size: 64,
                        color: AppColors.textLight,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Plant Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.greenBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.eco,
                      color: AppColors.greenIcon,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.result.plantName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Confidence Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Prédiction IA',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (widget.result.diseaseName?.toLowerCase() ==
                                  'healthy')
                              ? AppColors.greenBg
                              : AppColors.redBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          (widget.result.diseaseName?.toLowerCase() ==
                                  'healthy')
                              ? 'Healthy'
                              : 'Diseased',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color:
                                (widget.result.diseaseName?.toLowerCase() ==
                                    'healthy')
                                ? AppColors.greenIcon
                                : AppColors.redIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Confiance de l\'IA',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${(widget.result.confidence * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: widget.result.confidence,
                      minHeight: 8,
                      backgroundColor: AppColors.lightGray,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Disease Detection Card
            if (widget.result.diseaseName != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            (widget.result.diseaseName?.toLowerCase() ==
                                'healthy')
                            ? AppColors.greenBg
                            : AppColors.orangeBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        (widget.result.diseaseName?.toLowerCase() == 'healthy')
                            ? Icons.check_circle_outline
                            : Icons.warning_amber_rounded,
                        color:
                            (widget.result.diseaseName?.toLowerCase() ==
                                'healthy')
                            ? AppColors.greenIcon
                            : AppColors.orangeIcon,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (widget.result.diseaseName?.toLowerCase() ==
                                    'healthy')
                                ? 'État de Santé'
                                : 'Maladie Détectée',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.result.diseaseName!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (widget.result.diseaseScientificName != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              '(${widget.result.diseaseScientificName})',
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                          if (widget.result.severity != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'Sévérité : ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getSeverityColor(
                                      widget.result.severity,
                                    ).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    widget.result.severity!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _getSeverityColor(
                                        widget.result.severity,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Recommendations Card
            if (widget.result.recommendations.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.blueIcon,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Recommandations',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...widget.result.recommendations.asMap().entries.map((
                      entry,
                    ) {
                      final index = entry.key;
                      final recommendation = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              index < widget.result.recommendations.length - 1
                              ? 12
                              : 0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.greenBg,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.greenIcon,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                recommendation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Treatment Plan Card
            if (widget.result.treatmentPlan != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cyanBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.cyanIcon.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.water_drop,
                          color: AppColors.cyanIcon,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Plan de Traitement',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.result.treatmentPlan!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handleShare,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Partager',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Enregistrer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
