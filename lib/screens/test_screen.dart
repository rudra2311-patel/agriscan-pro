import 'package:agriscan_pro/utils/plant_disease_classifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
 // Ensure this path is correct

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final PlantDiseaseClassifier _classifier = PlantDiseaseClassifier();

  String _status = 'Ready to test';
  String _result = '';
  bool _isLoading = false;
  bool _modelLoaded = false;
  final String _testImagePath = 'assets/test_images/Tomato_Late_Blight.jpg';

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  /// Load the TensorFlow Lite model
  Future<void> _loadModel() async {
    setState(() {
      _isLoading = true;
      _status = 'Loading model...';
    });

    final success = await _classifier.loadModel();

    setState(() {
      _isLoading = false;
      _modelLoaded = success;
      _status = success
          ? 'Model loaded successfully! Ready to test.'
          : 'Failed to load model. Check your assets.';
    });
  }

  /// Run test classification
  Future<void> _runTest() async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Model not loaded yet!')));
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Running classification test...';
      _result = '';
    });

    try {
      // The screen is now responsible for loading the image data.
      final byteData = await rootBundle.load(_testImagePath);
      final testImage = img.decodeImage(byteData.buffer.asUint8List());

      if (testImage == null) {
        setState(() {
          _isLoading = false;
          _status = 'Error: Could not load test image';
          _result =
              'Make sure $_testImagePath exists in your assets folder.';
        });
        return;
      }

      // Run classification
      final prediction = await _classifier.classifyPlantDisease(testImage);

      setState(() {
        _isLoading = false;
        _status = 'Classification completed!';
        _result = prediction;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Test failed';
        _result = 'Error: $e';
      });
    }
  }

  // --- FIX START ---
  // The dispose method on the classifier is not strictly necessary for this test screen,
  // so we can remove the call to it to fix the error.
  @override
  void dispose() {
    // _classifier.dispose(); // This line is removed
    super.dispose();
  }
  // --- FIX END ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriScan Model Test'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              color: _modelLoaded
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _modelLoaded ? Icons.check_circle : Icons.warning,
                      color: _modelLoaded ? Colors.green : Colors.orange,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Model Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Test Button
            ElevatedButton(
              onPressed: _isLoading ? null : _runTest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Processing...'),
                      ],
                    )
                  : const Text(
                      'Run Classification Test',
                      style: TextStyle(fontSize: 16),
                    ),
            ),

            const SizedBox(height: 24),

            // Results Card
            if (_result.isNotEmpty)
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.analytics, color: Colors.blue, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        'Prediction Result',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _result,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Instructions:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1. Ensure your model is in assets/models/',
                  ),
                  const Text('2. Ensure your labels.txt is in assets/models/'),
                  const Text('3. Ensure your test image is in assets/test_images/'),
                  const Text('4. Tap the test button to run classification'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}