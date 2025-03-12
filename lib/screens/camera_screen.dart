import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cosmetic/screens/product_detail_screen.dart';
import 'package:cosmetic/model.dart'; // Model sınıfını import edin

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final Model _model = Model(); // Model sınıfını ekleyin

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _model.loadModel(); // Modeli yükle
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        print("Hata: Cihazda kullanılabilir kamera bulunamadı.");
        return;
      }

      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("Kamera başlatılırken hata oluştu: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

Future<void> _takePicture() async {
  try {
    if (_initializeControllerFuture != null) {
      await _initializeControllerFuture;
    } else {
      print("Kamera henüz başlatılmadı.");
      return;
    }

    final image = await _controller!.takePicture();
    if (!mounted) return;

    // Resmi Model ile tahmin et
    Uint8List? imageBytes = await File(image.path).readAsBytes();

    // imageBytes null kontrolü
    if (imageBytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resim yüklenirken bir hata oluştu.')),
        );
      }
      return;
    }

    String prediction = await _model.classify(imageBytes);

    // prediction null kontrolü
    if (prediction.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tahmin yapılamadı.')),
        );
      }
      return;
    }

    // ProductDetailScreen'e geçiş yap
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            imagePath: image.path,
            productName: prediction,
          ),
        ),
      );
    }
  } catch (e) {
    print("Hata: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kamera')),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller!);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
