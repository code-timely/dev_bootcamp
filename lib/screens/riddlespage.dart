import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';

class RiddlesPage extends StatefulWidget {
  const RiddlesPage({super.key});

  @override
  State<RiddlesPage> createState() => _RiddlesPageState();
}

class _RiddlesPageState extends State<RiddlesPage> {
  List<dynamic> riddles = [];
  bool isLoading = true;
  final String apiKey = 'bsu3Nh112YxP9gZW+HIfqw==l19KUWeR8A6toWaz';
  late CancelToken cancelToken;  // To cancel ongoing requests

  @override
  void initState() {
    super.initState();
    cancelToken = CancelToken();  // Initialize cancel token
    fetchRiddles();
  }

  Future<void> fetchRiddles() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await Dio().get(
        'https://api.api-ninjas.com/v1/riddles',
        options: Options(
          headers: {
            'X-Api-Key': apiKey,
          },
        ),
        queryParameters: {
          'limit': 10, 
        },
        cancelToken: cancelToken,  // Attach cancel token
      );

      if (mounted) {  // Check if the widget is still mounted before updating the state
        setState(() {
          riddles = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    cancelToken.cancel();  // Cancel any ongoing requests when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Riddles'),
        centerTitle: true,
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
                          'Hang tight, fetching riddles...',
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
                  : ListView.builder(
                      itemCount: riddles.length,
                      itemBuilder: (context, index) {
                        final riddle = riddles[index];
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  riddle['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.indigo,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  riddle['question'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Answer: ${riddle['answer']}',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          // Refresh Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: fetchRiddles,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Riddles'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
