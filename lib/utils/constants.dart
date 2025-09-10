import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2E7D32);
  static const secondary = Color(0xFF81C784);
  static const background = Color(0xFFF1F8E9);
  static const surface = Colors.white;
  static const onPrimary = Colors.white;
  static const onSurface = Colors.black87;
  static const error = Color(0xFFD32F2F);
}

class AppStrings {
  static const appName = 'AgriScan Pro';
  static const scanCrop = 'Scan Your Crop';
  static const history = 'Scan History';
  static const welcomeTitle = 'Welcome to AgriScan Pro';
  static const welcomeSubtitle = 'AI-powered crop disease detection at your fingertips';
  static const scanButton = 'Scan Crop Disease';
  static const historyButton = 'View Scan History';
  static const cameraTitle = 'Scan Crop';
  static const resultsTitle = 'Scan Results';
  static const takePicture = 'Take Picture';
  static const scanAnother = 'Scan Another';
  static const home = 'Home';
  static const historyComingSoon = 'History feature coming soon!';
  static const cameraInstructions = 'Point camera at crop leaves and tap the button to scan';
  static const initializingCamera = 'Initializing camera...';
  static const cameraNotAvailable = 'Camera not available';
  static const cameraError = 'Camera Error';
  static const failedToTakePicture = 'Failed to take picture';
  static const pictureTaken = 'Picture taken successfully!';
}

class AppDimensions {
  static const padding = 20.0;
  static const cardElevation = 8.0;
  static const buttonHeight = 56.0;
  static const iconSize = 24.0;
  static const largeIconSize = 80.0;
  static const borderRadius = 12.0;
  static const cardBorderRadius = 16.0;
}

class AppTextStyles {
  static const heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  
  static const body1 = TextStyle(
    fontSize: 16,
  );
  
  static const body2 = TextStyle(
    fontSize: 14,
  );
  
  static const button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}