import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class Model {
  late Interpreter _interpreter;
  bool isModelLoaded = false;
  final List<String> _productNames = ["ISANA VÜCUT LOSYONU", "DOA NEMLENDİRİCİ KREM", "OTACI GÜL SUYU"];

  Future<void> loadModel() async {
    try {
      var options = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset('assets/model.tflite', options: options);
      print("Model başarıyla yüklendi");
      print("Model bilgisi: ${_interpreter.getInputTensor(0).shape}");
      print("Model tipi: ${_interpreter.getInputTensor(0).type}");
      isModelLoaded = true;
    } catch (e) {
      isModelLoaded = false;
      print("Model yüklenirken hata oluştu: $e");
    }

    print("Model Input Shape: ${_interpreter.getInputTensor(0).shape}");
    print("Model Input Type: ${_interpreter.getInputTensor(0).type}");
    print("Model Output Shape: ${_interpreter.getOutputTensor(0).shape}");
    print("Model Output Type: ${_interpreter.getOutputTensor(0).type}");
  }

  List<List<List<List<double>>>> preprocessImage(img.Image? image) {
    if (image == null) {
      throw Exception("Görsel işlenemedi. Lütfen başka bir görsel seçin.");
    }

    int width = 224;
    int height = 224;

    // Resmi yeniden boyutlandır
    img.Image resizedImage = img.copyResize(image, width: width, height: height);

    // Giriş tensörünü oluştur
    List<List<List<List<double>>>> input = List.generate(
      1,
      (_) => List.generate(
        height,
        (y) => List.generate(
          width,
          (x) {
            int pixel = resizedImage.getPixel(x, y);
            return [
              ((pixel >> 16) & 0xFF) / 255.0, // R
              ((pixel >> 8) & 0xFF) / 255.0,  // G
              (pixel & 0xFF) / 255.0          // B
            ];
          },
        ),
      ),
    );

    return input;
  }

  Future<String> classify(Uint8List imageBytes) async {
    if (!isModelLoaded) {
      print("Model henüz yüklenmedi, işlem yapılamıyor.");
      return "Model yüklenmedi";
    }

    try {
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception("Görsel işlenemedi. Lütfen başka bir görsel seçin.");
      }

      List<List<List<List<double>>>> input = preprocessImage(image);
      int numClasses = _productNames.length;

      // Çıktıyı oluştur
      var output = List.generate(1, (_) => List.filled(numClasses, 0.0));

      print("Processed Input: ${input[0][0][0]}"); // İlk pikselin RGB değerlerini kontrol et
      print("Running Model...");

      _interpreter.run(input, output);

      print("Model Çıktısı: $output");

      List<double> outputProbabilities = List<double>.from(output[0]);
      int predictedIndex = outputProbabilities.indexWhere(
        (e) => e == outputProbabilities.reduce((a, b) => a > b ? a : b)
      );

      return getProductName(predictedIndex);
    } catch (e) {
      print("Model tahmininde hata oluştu: $e");
      return "Tahmin Hatası";
    }
  }

  String getProductName(int index) {
    return (index < _productNames.length) ? _productNames[index] : "Bilinmeyen Ürün";
  }
}