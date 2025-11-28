import 'package:flutter/material.dart';
import 'dart:io';
import '../../constants/colors.dart';
import '../../widgets/auth_button.dart';
import 'scan_loading_screen.dart';

class PlantTypeSelectionScreen extends StatefulWidget {
  final String imagePath;

  const PlantTypeSelectionScreen({super.key, required this.imagePath});

  @override
  State<PlantTypeSelectionScreen> createState() =>
      _PlantTypeSelectionScreenState();
}

class _PlantTypeSelectionScreenState extends State<PlantTypeSelectionScreen> {
  String? _selectedPlantType;

  final List<String> _plantTypes = [
    'Tomate',
    'Pomme de terre',
    'Poivron',
    'Aubergine',
    'Concombre',
    'Courgette',
    'Laitue',
    'Carotte',
    'Haricot',
    'Pois',
  ];

  void _handleContinue() {
    if (_selectedPlantType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un type de plante'),
          backgroundColor: AppColors.redIcon,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScanLoadingScreen(
          imagePath: widget.imagePath,
          plantType: _selectedPlantType!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Type de Plante',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Preview
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
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
                  File(widget.imagePath),
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

            const SizedBox(height: 32),

            // Title
            const Text(
              'Quel type de plante analysez-vous?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Sélectionnez le type de plante pour une analyse plus précise',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 24),

            // Plant Type Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedPlantType == null
                      ? AppColors.divider
                      : AppColors.primary,
                  width: _selectedPlantType == null ? 1 : 2,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPlantType,
                  isExpanded: true,
                  hint: const Text(
                    'Sélectionnez un type de plante',
                    style: TextStyle(fontSize: 14, color: AppColors.textLight),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  items: _plantTypes.map((String plantType) {
                    return DropdownMenuItem<String>(
                      value: plantType,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.eco,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(plantType),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPlantType = newValue;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Continue Button
            AuthButton(
              text: 'Continuer l\'analyse',
              onPressed: _handleContinue,
            ),
          ],
        ),
      ),
    );
  }
}
