import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/stat_card.dart';
import '../widgets/feature_card.dart';
import 'scanner_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      // Navigate to Scanner
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const ScannerScreen(),
      ).then((_) {
        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (index == 2) {
      // Navigate to History
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistoryScreen()),
      ).then((_) {
        setState(() {
          _currentIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
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
                    const Text(
                      'Bienvenue sur BioScanD',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Diagnostiquez instantanément les maladies de vos plantes grâce à l\'IA',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _onNavTap(1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.crop_free, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Démarrer un Scan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Statistics Cards
              Row(
                children: const [
                  Expanded(
                    child: StatCard(
                      icon: Icons.access_time,
                      iconColor: AppColors.blueIcon,
                      backgroundColor: AppColors.blueBg,
                      count: '0',
                      label: 'Scans',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.check_circle_outline,
                      iconColor: AppColors.greenIcon,
                      backgroundColor: AppColors.greenBg,
                      count: '0',
                      label: 'Sain',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.warning_amber_outlined,
                      iconColor: AppColors.redIcon,
                      backgroundColor: AppColors.redBg,
                      count: '0',
                      label: 'Critique',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Fonctionnalités Section
              const Text(
                'Fonctionnalités',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              // Feature Cards
              FeatureCard(
                icon: Icons.crop_free,
                iconColor: AppColors.purpleIcon,
                backgroundColor: AppColors.purpleBg,
                title: 'Scan Intelligent',
                description: 'Analysez vos plantes en temps réel avec l\'IA',
                onTap: () => _onNavTap(1),
              ),

              const SizedBox(height: 12),

              const FeatureCard(
                icon: Icons.trending_up,
                iconColor: AppColors.orangeIcon,
                backgroundColor: AppColors.orangeBg,
                title: 'Recommandations',
                description: 'Recevez des conseils agronomiques personnalisés',
              ),

              const SizedBox(height: 12),

              FeatureCard(
                icon: Icons.check_circle_outline,
                iconColor: AppColors.cyanIcon,
                backgroundColor: AppColors.cyanBg,
                title: 'Suivi Complet',
                description: 'Historique et évolution de vos cultures',
                onTap: () => _onNavTap(2),
              ),

              const SizedBox(height: 24),
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
}
