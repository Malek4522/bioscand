class ScanResult {
  final String plantName;
  final String plantType;
  final double confidence;
  final String? diseaseName;
  final String? diseaseScientificName;
  final String? severity;
  final List<String> recommendations;
  final String? treatmentPlan;
  final DateTime timestamp;
  final String imagePath;

  final String? prediction;
  final Map<String, dynamic>? environmentalData;

  ScanResult({
    required this.plantName,
    required this.plantType,
    required this.confidence,
    this.diseaseName,
    this.diseaseScientificName,
    this.severity,
    required this.recommendations,
    this.treatmentPlan,
    required this.timestamp,
    required this.imagePath,
    this.prediction,
    this.environmentalData,
  });

  // Mock data for demonstration
  static ScanResult getMockResult(
    String plantType,
    String imagePath, {
    String? prediction,
    Map<String, dynamic>? environmentalData,
    String? diseaseClass,
    double? confidence,
    String? medicine,
    String? dosage,
  }) {
    // Build recommendations and treatment plan from LLM data if available
    List<String> recommendations;
    String? treatmentPlan;

    print('DEBUG [ScanResult]: medicine=$medicine, dosage=$dosage');

    if (medicine != null && dosage != null) {
      // Use LLM-generated recommendations
      print('DEBUG [ScanResult]: Using LLM-generated recommendations');
      recommendations = ['Médicament recommandé: $medicine', 'Dosage: $dosage'];
      treatmentPlan = 'Traitement: $medicine. Dosage: $dosage';
    } else {
      // Fallback to default recommendations for healthy plants or errors
      print(
        'DEBUG [ScanResult]: Using default recommendations (medicine or dosage is null)',
      );
      recommendations = [
        'Maintenir un arrosage régulier',
        'Assurer une bonne circulation d\'air',
        'Surveiller l\'apparition de symptômes',
      ];
      treatmentPlan = null;
    }

    print(
      'DEBUG [ScanResult]: Created ${recommendations.length} recommendations',
    );
    print('DEBUG [ScanResult]: Recommendations: $recommendations');

    return ScanResult(
      plantName: plantType,
      plantType: plantType,
      confidence: confidence ?? 0.94,
      diseaseName: diseaseClass,
      recommendations: recommendations,
      treatmentPlan: treatmentPlan,
      timestamp: DateTime.now(),
      imagePath: imagePath,
      prediction: prediction ?? 'Moderate Stress',
      environmentalData: environmentalData,
    );
  }
}
