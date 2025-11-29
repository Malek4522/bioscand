class HistoryItem {
  final String imageBase64;
  final String disease;

  HistoryItem({required this.imageBase64, required this.disease});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      imageBase64: json['image'] as String,
      disease: json['disease'] as String,
    );
  }
}
