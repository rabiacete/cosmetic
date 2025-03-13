import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cosmetic/screens/camera_screen.dart';
import 'package:cosmetic/screens/product_detail_screen.dart';
import 'package:cosmetic/model.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  /// 📌 **Galeriden resim seçme fonksiyonu**
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        Uint8List imageBytes = await File(pickedFile.path).readAsBytes();
        String prediction = await _model.classify(imageBytes); // Modelden ürün ismi al

        if (mounted) {  // Ekran hala aktif mi kontrol et
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resim seçilmedi. Lütfen tekrar deneyin.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            height: 120, // Logonun boyutunu büyüttük
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 250.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: [
              'assets/slider1.png',
              'assets/slider2.png',
              'assets/slider3.png',
            ].map((i) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(i),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'NASIL KULLANILIR',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '1. Kamerayı kullanarak veya galeriden bir resim seçerek cilt ürününü tanıyın.📷\n'
                          '2. Model, seçtiğiniz resimdeki ürünü tanıyacak ve detaylarını gösterecek.\n'
                          '3. Ürün detayları sayfasında tanımlanan ürünün bilgilerini görüntüleyin.🦋',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraScreen(model: _model)),
                      );
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Kamerayı Kullan'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery, // 📌 **Galeriden resim seçme fonksiyonunu çağır**
                    icon: const Icon(Icons.photo),
                    label: const Text('Galeriden Seç'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}