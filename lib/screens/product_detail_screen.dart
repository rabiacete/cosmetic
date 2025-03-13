import 'package:flutter/material.dart';
import 'dart:io';

class ProductDetailScreen extends StatelessWidget {
  final String imagePath;
  final String productName;

  const ProductDetailScreen({
    super.key,
    required this.imagePath,
    required this.productName,
  });

  List<Map<String, String>> getIngredients(String productName) {
    Map<String, List<Map<String, String>>> productData = {
    "ISANA VÜCUT LOSYONU": [
  {"İçerik": "Urea", "Risk": "Düşük"},
  {"İçerik": "Isopropyl myristate", "Risk": "Düşük"},
  {"İçerik": "Bisabolol", "Risk": "Düşük"},
  {"İçerik": "Caprylhydroxamic acid", "Risk": "Düşük"},
  {"İçerik": "Piroctone olamine", "Risk": "Düşük"},
  {"İçerik": "Sodium lactate", "Risk": "Düşük"},
  {"İçerik": "Lactic acid", "Risk": "Düşük"},
  {"İçerik": "Citric acid", "Risk": "Düşük"}
],
   "DOA GÜNEŞ KREMİ": [
  {"İçerik": "Phenoxyethanol", "Risk": "Orta"},
  {"İçerik": "Aloe Barbadensis Leaf Juice", "Risk": "Düşük"},
  {"İçerik": "Sodium Lactate", "Risk": "Düşük"},
        {"İçerik": "Peg-7 Glycercyl cocoate", "Risk": "Düşük"},
        {"İçerik": "Sodium pca", "Risk": "Düşük"},
        {"İçerik": "Bisabolol", "Risk": "Düşük"},
        {"İçerik": "Ceteareth-12", "Risk": "Düşük"},
        {"İçerik": "Ceteareth-20", "Risk": "Düşük"},

      ],
      "ARKO NEM": [
  {"İçerik": "Butylphenyl methylpropional", "Risk": "Yüksek"},
  {"İçerik": "Paraffinum liquidum", "Risk": "Orta"},
  {"İçerik": "Triethanolamine", "Risk": "Orta"},
  {"İçerik": "Petrolatum", "Risk": "Orta"},
  {"İçerik": "Phenoxyethanol", "Risk": "Orta"},
  {"İçerik": "Linalool", "Risk": "Orta"},
  {"İçerik": "Limonene", "Risk": "Orta"},
  {"İçerik": "Citronellol", "Risk": "Orta"},
  {"İçerik": "Citral", "Risk": "Orta"},
  {"İçerik": "Cetyl alcohol", "Risk": "Düşük"},
      ],
      "CREAM CO YÜZ JELİ": [
        {"İçerik": "Salisilik Asit", "Risk": "Yüksek"},
        {"İçerik": "Hyaluronik Asit", "Risk": "Düşük"},
      ],
      "MARUDERM KİL MASKESİ": [
        {"İçerik": "Kil", "Risk": "Düşük"},
        {"İçerik": "Parfüm", "Risk": "Orta"},
      ],
    };

    return productData[productName] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> ingredients = getIngredients(productName);
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(productName, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(File(imagePath), height: 250, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'İçindekiler ve Risk Durumu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  String riskLevel = ingredients[index]["Risk"] ?? "";
                  Color riskColor = riskLevel == "Yüksek"
                      ? Colors.red
                      : riskLevel == "Orta"
                          ? Colors.orange
                          : Colors.green;

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(ingredients[index]["İçerik"] ?? ""),
                      trailing: Text(
                        riskLevel,
                        style: TextStyle(fontWeight: FontWeight.bold, color: riskColor),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}