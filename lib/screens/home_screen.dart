import 'dart:io';
import 'dart:typed_data';
import 'package:cosmetic/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cosmetic/model.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Model _model = Model();

  @override
  void initState() {
    super.initState();
    _model.loadModel(); // Uygulama başlarken modeli yükle
  }

Future<void> _pickImage(BuildContext context, ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);

  if (pickedFile != null) {
    try {
      Uint8List imageBytes = await File(pickedFile.path).readAsBytes();

      if (_model.isModelLoaded) {
        print('Model başarıyla yüklendi!');

        String prediction = await _model.classify(imageBytes);

        if (mounted) {  // Ekranın hala aktif olup olmadığını kontrol et
          print('Tahmin sonucu: $prediction');

          if (context.mounted) {  // `context` hâlâ aktif mi?
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
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Model yüklenmedi. Lütfen tekrar deneyin.')),
          );
        }
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


  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Kameradan Çek"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Galeriden Seç"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(context, ImageSource.gallery); // Galeriye git
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PureSkin')),
      body: const Center(
        child: Text('BURASI BİLGİLENDİRME', style: TextStyle(fontSize: 18)),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt),
                iconSize: 30,
                onPressed: () => _showImageSourceDialog(context), // Dialog göster
              ),
            ],
          ),
        ),
      ),
    );
  }
}
