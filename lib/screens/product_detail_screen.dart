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
      "Ürün A": "Cilt dostu bileşenler içerir.",
      "Ürün B": "Paraben ve sülfat içermez.",
      "Ürün C": "Organik sertifikalıdır.",
    };
    return productDetails[productName] ?? "Bilgi bulunamadı.";
  }
}
