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
  });

  // Mock data for demonstration
  static ScanResult getMockResult(String plantType, String imagePath) {
    return ScanResult(
      plantName: plantType,
      plantType: plantType,
      confidence: 0.94,
      diseaseName: 'Mildiou',
      diseaseScientificName: 'Phytophthora infestans',
      severity: 'Modérée',
      recommendations: [
        'Retirer immédiatement les feuilles infectées',
        'Améliorer la circulation d\'air autour des plants',
        'Éviter l\'arrosage par aspersion',
        'Appliquer un fongicide à base de cuivre',
      ],
      treatmentPlan:
          'Traitement fongicide recommandé : Bouillie bordelaise (sulfate de cuivre) à appliquer tous les 7-10 jours. Éliminer les parties infectées et brûler les débris végétaux.',
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );
  }
}
