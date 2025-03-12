import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cosmetic/model.dart';
import 'package:cosmetic/screens/product_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  final Model model;
  const GalleryScreen({super.key, required this.model});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        Uint8List imageBytes = await File(pickedFile.path).readAsBytes();
        String prediction = await widget.model.classify(imageBytes);

        if (mounted && context.mounted) {  // Ekranın ve `context`in hala aktif olup olmadığını kontrol et
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                imagePath: pickedFile.path,
                productName: prediction,
              ),
            ),
          );
        }
      } catch (e) {
        print('Hata oluştu: $e');
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resim seçilmedi. Lütfen tekrar deneyin.')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pickImage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galeri')),
      body: const Center(
        child: Text('Lütfen galeriden bir resim seçin.'),
      ),
    );
  }
}