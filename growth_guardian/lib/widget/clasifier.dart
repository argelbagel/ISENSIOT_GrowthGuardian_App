import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:convert';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:http/http.dart' as http;

List<String> classes = ['Adiantum caudatum', 'Dypsis lutescens', 'Ficus elastica', 'Narcissus papyraceus', 'Rhododendron simsii'];


Future<String> classifyImage(img.Image image) async{
  
  img.Image resizedImage = img.copyResize(image, width: 180, height: 180);

  // Convert the resized image to a 1D Float32List.
  Float32List inputBytes = Float32List(1 * 180 * 180 * 3);
  int pixelIndex = 0;
  for (int y = 0; y < resizedImage.height; y++) {
    for (int x = 0; x < resizedImage.width; x++) {
      dynamic pixel = resizedImage.getPixel(x, y);
      inputBytes[pixelIndex++] = img.getRed(pixel) / 127.5 - 1.0;
      inputBytes[pixelIndex++] = img.getGreen(pixel) / 127.5 - 1.0;
      inputBytes[pixelIndex++] = img.getBlue(pixel) / 127.5 - 1.0;
    }
  }

  final input = inputBytes.reshape([1, 180, 180, 3]);
  print(input.shape);

  final response = await classifyImageRequest(input);

  final predictions = json.decode(response.body)["predictions"][0];

  double maxElement = predictions[0];

  predictions.forEach((prediction){
    if(prediction > maxElement) maxElement = prediction;
  });

  return classes[predictions.indexOf(maxElement)];
}

Future<http.Response> classifyImageRequest(dynamic convertedImage) async{
  print("Getting post thingy");
  return http.post(
    Uri.parse("http://192.168.1.190:8501/v1/models/plantModel:predict"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      "signature_name": "serving_default",
      "instances":convertedImage,
    }),
  );
}