import 'package:flutter/material.dart';
import 'dart:convert';
import '../constants/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/api_service.dart';
import '../models/history_item.dart';
import 'scanner_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final int _currentIndex = 2;
  String _selectedSeverity = 'Toutes les sévérités';
  List<HistoryItem> _historyItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
  }

  Future<void> _loadHistoryData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getHistoryData();
      final items = data.map((json) => HistoryItem.fromJson(json)).toList();

      setState(() {
        _historyItems = items;
        _isLoading = false;
      });
    } catch (e) {
      print('DEBUG: Error loading history: $e');
      setState(() {
        _errorMessage = 'Erreur lors du chargement de l\'historique';
        _isLoading = false;
      });
    }
  }

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pop(context);
    } else if (index == 1) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const ScannerScreen(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Historique des Scans',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une plante ou maladie...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textLight,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Filter Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_list,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSeverity,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          items:
                              [
                                'Toutes les sévérités',
                                'Faible',
                                'Modéré',
                                'Critique',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedSeverity = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Statistics Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bar_chart, color: AppColors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Statistiques',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('${_historyItems.length}', 'Total'),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.white.withOpacity(0.3),
                        ),
                        _buildStatItem(
                          '${_historyItems.where((item) => item.disease.toLowerCase() == 'healthy').length}',
                          'Sains',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.white.withOpacity(0.3),
                        ),
                        _buildStatItem(
                          '${_historyItems.where((item) => item.disease.toLowerCase() != 'healthy').length}',
                          'Malades',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Content based on state
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48.0),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.redIcon,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadHistoryData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                        ),
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              else if (_historyItems.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search,
                        size: 64,
                        color: AppColors.textLight.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Aucun résultat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Commencez par scanner une plante',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                // History List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _historyItems.length,
                  itemBuilder: (context, index) {
                    final item = _historyItems[index];
                    return _buildHistoryCard(item);
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHistoryCard(HistoryItem item) {
    final isHealthy = item.disease.toLowerCase() == 'healthy';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Image from base64
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                base64Decode(item.imageBase64),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: AppColors.lightGray,
                    child: const Icon(
                      Icons.image,
                      color: AppColors.textLight,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // Disease info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isHealthy ? AppColors.greenBg : AppColors.redBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isHealthy ? 'Healthy' : 'Diseased',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isHealthy
                            ? AppColors.greenIcon
                            : AppColors.redIcon,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.disease,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow icon
            const Icon(
              Icons.chevron_right,
              color: AppColors.textLight,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
