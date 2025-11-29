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
  final _formKey = GlobalKey<FormState>();

  // Controllers for environmental data
  final _soilMoistureController = TextEditingController(text: '30');
  final _ambientTempController = TextEditingController(text: '24');
  final _soilTempController = TextEditingController(text: '20');
  final _humidityController = TextEditingController(text: '65');
  final _lightIntensityController = TextEditingController(text: '5500');
  final _soilPhController = TextEditingController(text: '6.5');
  final _nitrogenController = TextEditingController(text: '40');
  final _phosphorusController = TextEditingController(text: '25');
  final _potassiumController = TextEditingController(text: '180');
  final _chlorophyllController = TextEditingController(text: '52');

  // Map of French display names to English API names
  final Map<String, String> _plantTypes = {
    'Pomme': 'apple',
    'Maïs': 'corn',
    'Orange': 'orange',
    'Pomme de terre': 'potato',
    'Tomate': 'tomato',
  };

  @override
  void dispose() {
    _soilMoistureController.dispose();
    _ambientTempController.dispose();
    _soilTempController.dispose();
    _humidityController.dispose();
    _lightIntensityController.dispose();
    _soilPhController.dispose();
    _nitrogenController.dispose();
    _phosphorusController.dispose();
    _potassiumController.dispose();
    _chlorophyllController.dispose();
    super.dispose();
  }

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

    if (_formKey.currentState!.validate()) {
      final environmentalData = {
        "Soil_Moisture": double.tryParse(_soilMoistureController.text) ?? 0,
        "Ambient_Temperature":
            double.tryParse(_ambientTempController.text) ?? 0,
        "Soil_Temperature": double.tryParse(_soilTempController.text) ?? 0,
        "Humidity": double.tryParse(_humidityController.text) ?? 0,
        "Light_Intensity": double.tryParse(_lightIntensityController.text) ?? 0,
        "Soil_pH": double.tryParse(_soilPhController.text) ?? 0,
        "Nitrogen_Level": double.tryParse(_nitrogenController.text) ?? 0,
        "Phosphorus_Level": double.tryParse(_phosphorusController.text) ?? 0,
        "Potassium_Level": double.tryParse(_potassiumController.text) ?? 0,
        "Chlorophyll_Content":
            double.tryParse(_chlorophyllController.text) ?? 0,
      };

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScanLoadingScreen(
            imagePath: widget.imagePath,
            plantType: _plantTypes[_selectedPlantType]!, // Use English API name
            plantTypeDisplay:
                _selectedPlantType!, // Pass French name for display
            environmentalData: environmentalData,
          ),
        ),
      );
    }
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
          'Données Environnementales',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Preview
              Container(
                width: double.infinity,
                height: 200,
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

              const SizedBox(height: 24),

              // Plant Type Dropdown
              const Text(
                'Type de Plante',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
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
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primary,
                    ),
                    items: _plantTypes.keys.map((String plantType) {
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

              const SizedBox(height: 24),

              const Text(
                'Paramètres Environnementaux',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              _buildInputField('Humidité du Sol (%)', _soilMoistureController),
              _buildInputField(
                'Température Ambiante (°C)',
                _ambientTempController,
              ),
              _buildInputField('Température du Sol (°C)', _soilTempController),
              _buildInputField('Humidité de l\'Air (%)', _humidityController),
              _buildInputField(
                'Intensité Lumineuse (Lux)',
                _lightIntensityController,
              ),
              _buildInputField('pH du Sol', _soilPhController),
              _buildInputField('Niveau d\'Azote (mg/kg)', _nitrogenController),
              _buildInputField(
                'Niveau de Phosphore (mg/kg)',
                _phosphorusController,
              ),
              _buildInputField(
                'Niveau de Potassium (mg/kg)',
                _potassiumController,
              ),
              _buildInputField(
                'Teneur en Chlorophylle',
                _chlorophyllController,
              ),

              const SizedBox(height: 32),

              // Continue Button
              AuthButton(
                text: 'Continuer l\'analyse',
                onPressed: _handleContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: AppColors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer une valeur';
              }
              if (double.tryParse(value) == null) {
                return 'Veuillez entrer un nombre valide';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
