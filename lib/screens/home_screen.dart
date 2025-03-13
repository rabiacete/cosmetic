import 'package:flutter/material.dart';
import 'package:cosmetic/screens/camera_screen.dart';
import 'package:cosmetic/screens/gallery_screen.dart';
import 'package:cosmetic/model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PureScan', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 100), // Logo
              const SizedBox(height: 30),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      '1. Kamerayı kullanarak veya galeriden bir resim seçerek cilt ürününü tanıyın.\n'
                      '2. Model, seçtiğiniz resimdeki ürünü tanıyacak ve detaylarını gösterecek.\n'
                      '3. Ürün detayları sayfasında tanımlanan ürünün bilgilerini görüntüleyin.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Cildinizi Önemsiyoruz...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Görsel tanıma ile cilt ürünlerini tanıyın.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GalleryScreen(model: _model)),
                  );
                },
                icon: const Icon(Icons.photo),
                label: const Text('Galeriden Seç'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}