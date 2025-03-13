import 'dart:io';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String imagePath;
  final String productName;

  const ProductDetailScreen({super.key, required this.imagePath, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Detayları')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.file(File(imagePath), height: 200),
          const SizedBox(height: 20),
          Text(
            "Tanımlanan Ürün: $productName",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text("İçerik: ${_getProductDetails(productName)}"),
        ],
      ),
    );
  }

  String _getProductDetails(String productName) {
    Map<String, String> productDetails = {
      "ISANA VÜCUT LOSYONU": "Cilt dostu bileşenler içerir.",
      "DOA NEMLENDİRİCİ KREM": "Paraben ve sülfat içermez.",
      "OTACI GÜL SUYU": "Organik sertifikalıdır.",
    };
    return productDetails[productName] ?? "Bilgi bulunamadı.";
  }
}
