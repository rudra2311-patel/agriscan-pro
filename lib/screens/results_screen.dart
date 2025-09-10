import 'package:flutter/material.dart';
import 'dart:io';
import 'camera_screen.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';

class ResultsScreen extends StatefulWidget {
  final String imagePath;

  const ResultsScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isAnalyzing = true;
  String? _diseaseName;
  double? _confidence;
  String? _symptoms;
  String? _treatment;
  String? _prevention;

  @override
  void initState() {
    super.initState();
    _simulateAIAnalysis();
  }

  // Simulate AI analysis with mock results for demonstration
  Future<void> _simulateAIAnalysis() async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _diseaseName = 'Leaf Blight';
        _confidence = 0.87;
        _symptoms = 'Brown spots on leaves, yellowing edges, wilting during day';
        _treatment = 'Apply copper-based fungicide every 7-10 days. Remove affected leaves and destroy them.';
        _prevention = 'Ensure good air circulation, avoid overhead watering, maintain proper plant spacing.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.resultsTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageCard(),
            const SizedBox(height: 20),
            _buildAnalysisCard(),
            if (!_isAnalyzing && _diseaseName != null) ...[
              const SizedBox(height: 20),
              _buildDiseaseInfoCard(),
              const SizedBox(height: 20),
              _buildTreatmentCard(),
            ],
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.primary.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Image captured successfully',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_isAnalyzing) ...[
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Analyzing crop image...',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Our AI is examining your crop for potential diseases',
                style: AppTextStyles.body2.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Icon(
                _diseaseName != null ? Icons.warning : Icons.check_circle,
                size: 50,
                color: _diseaseName != null ? AppColors.error : Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                _diseaseName ?? 'No Disease Detected',
                style: AppTextStyles.heading1.copyWith(
                  color: _diseaseName != null ? AppColors.error : Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              if (_confidence != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Confidence: ${(_confidence! * 100).toStringAsFixed(1)}%',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _confidence!,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Disease Information',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_symptoms != null) ...[
              _buildInfoSection('Symptoms', _symptoms!, Icons.visibility),
              const SizedBox(height: 16),
            ],
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Early detection and treatment are crucial for crop health',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.healing,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Treatment & Prevention',
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_treatment != null) ...[
              _buildInfoSection('Treatment', _treatment!, Icons.medical_services),
              const SizedBox(height: 16),
            ],
            
            if (_prevention != null) ...[
              _buildInfoSection('Prevention', _prevention!, Icons.shield),
              const SizedBox(height: 16),
            ],
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                border: Border.all(
                  color: Colors.green.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Consult with local agricultural experts for best results',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            content,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.onSurface,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: AppStrings.scanAnother,
                icon: Icons.camera_alt,
                onPressed: _scanAnother,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: AppStrings.home,
                icon: Icons.home,
                isOutlined: true,
                onPressed: _goHome,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Additional action buttons
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Save Result',
                icon: Icons.bookmark,
                isOutlined: true,
                onPressed: _saveResult,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'Share',
                icon: Icons.share,
                isOutlined: true,
                onPressed: _shareResult,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _scanAnother() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );
  }

  void _goHome() {
    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  void _saveResult() {
    // TODO: Implement save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Save functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareResult() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
