import 'package:flutter/material.dart';
import 'camera_screen.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.agriculture,
                        size: AppDimensions.largeIconSize,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.welcomeTitle,
                        style: AppTextStyles.heading1.copyWith(
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.welcomeSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Main Action Buttons
              CustomButton(
                text: AppStrings.scanButton,
                icon: Icons.camera_alt,
                onPressed: () => _navigateToCamera(context),
              ),
              
              const SizedBox(height: 16),
              
              CustomButton(
                text: AppStrings.historyButton,
                icon: Icons.history,
                isOutlined: true,
                onPressed: () => _showHistoryComingSoon(context),
              ),
              
              const SizedBox(height: 40),
              
              // Features Section
              Text(
                'Key Features',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              
              const FeatureCard(
                icon: Icons.offline_bolt,
                title: 'Offline Detection',
                description: 'Works completely offline without internet',
              ),
              
              const SizedBox(height: 12),
              
              const FeatureCard(
                icon: Icons.speed,
                title: 'Instant Results',
                description: 'Get AI-powered diagnosis in seconds',
              ),
              
              const SizedBox(height: 12),
              
              const FeatureCard(
                icon: Icons.lightbulb_outline,
                title: 'Smart Recommendations',
                description: 'Receive treatment and prevention advice',
              ),
              
              const SizedBox(height: 40),
              
              // App Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Designed for farmers in rural areas with limited internet connectivity',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );
  }

  void _showHistoryComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.historyComingSoon),
        duration: Duration(seconds: 2),
      ),
    );
  }
}