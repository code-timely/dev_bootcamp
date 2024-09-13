import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:logger/web.dart';
import 'package:lottie/lottie.dart';

final log = Logger();

class ImagePage extends StatefulWidget {

  const ImagePage({super.key});
  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  Uint8List? imageBytes;
  bool isLoading = true;
  final String apiKey = 'bsu3Nh112YxP9gZW+HIfqw==l19KUWeR8A6toWaz';

  @override
  void initState() {
    super.initState();
    fetchRandomImage();
  }

  Future<void> fetchRandomImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await Dio().get(
        'https://api.api-ninjas.com/v1/randomimage',
        options: Options(
          headers: {
            'X-Api-Key': apiKey,
            'Accept': 'image/jpg',
          },
          responseType: ResponseType.bytes, 
        ),
        queryParameters: {
          'category': 'abstract', 
          'width': 640, 
          'height': 480,
        },
      );

      setState(() {
        imageBytes = response.data;
        isLoading = false;
      });
    } catch (e) {
      log.e('Error fetching image: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: isLoading
                  ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/loading.json', 
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 35), 
              Text(
                'Hang tight, fetching an abstract image!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10), 
              Text(
                'This might take a few seconds...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
                  : imageBytes != null
                      ? Container(
                          width: 350, 
                          height: 420,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.memory(
                              imageBytes!,
                              fit: BoxFit.cover, 
                              width: 300,  
                              height: 400,
                            ),
                          ),
                        )
                      : const Text('No Image Available'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: fetchRandomImage,
              child: const Text('Shuffle Image'),
            ),
          ),
        ],
      ),
    );
  }
}
