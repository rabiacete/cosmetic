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
                MaterialPageRoute(builder: (context) => CameraScreen(model: _model)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Galeriden Seç"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GalleryScreen(model: _model)),
              );
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
        child: Text('BURASI BİLGİLENDİRME ', style: TextStyle(fontSize: 18)),
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