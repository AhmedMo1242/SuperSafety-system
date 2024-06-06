// Page 4: Real-Time Camera View
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:official_pbl/components/navbar.dart';

class CameraViewPage extends StatefulWidget {
  @override
  _CameraViewPageState createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Camera View'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.yellow[800],
      body: _controller != null && _controller.value.isInitialized
          ? CameraPreview(_controller)
          : CircularProgressIndicator(),
      bottomNavigationBar: navbar(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
