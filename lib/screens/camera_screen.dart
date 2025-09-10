import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'results_screen.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      _cameras = await availableCameras();
      
      if (_cameras.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No cameras available on this device';
        });
        return;
      }

      // Find back camera or use first available
      CameraDescription camera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to initialize camera: ${e.toString()}';
        });
      }
    }
  }

  void _disposeCamera() {
    _controller?.dispose();
    _controller = null;
    _isCameraInitialized = false;
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      _showErrorSnackBar('Camera not ready');
      return;
    }

    try {
      LoadingDialog.show(context, 'Capturing image...');

      final XFile image = await _controller!.takePicture();

      if (mounted) {
        LoadingDialog.hide(context);
        
        // Navigate to results screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              imagePath: image.path,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        LoadingDialog.hide(context);
        _showErrorSnackBar('Failed to capture image: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.cameraError),
        content: Text(_errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeCamera();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(AppStrings.cameraTitle),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingView();
    } else if (_errorMessage.isNotEmpty) {
      return _buildErrorView();
    } else if (_isCameraInitialized) {
      return _buildCameraView();
    } else {
      return _buildNotAvailableView();
    }
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            AppStrings.initializingCamera,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showErrorDialog();
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotAvailableView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 64,
            color: Colors.white54,
          ),
          SizedBox(height: 16),
          Text(
            AppStrings.cameraNotAvailable,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        // Camera Preview
        Positioned.fill(
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: CameraPreview(_controller!),
          ),
        ),

        // Instructions Overlay
        Positioned(
          top: 40,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: const Text(
              AppStrings.cameraInstructions,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Camera Controls
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: _buildCameraControls(),
        ),
      ],
    );
  }

  Widget _buildCameraControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery placeholder (for future implementation)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.photo_library,
              color: Colors.white,
              size: 28,
            ),
          ),

          // Capture Button
          GestureDetector(
            onTap: _takePicture,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 4,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 40,
                color: AppColors.primary,
              ),
            ),
          ),

          // Switch Camera placeholder (for future implementation)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.flip_camera_android,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}