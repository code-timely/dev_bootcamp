import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CryptoPricePage extends StatefulWidget {
  @override
  _CryptoPricePageState createState() => _CryptoPricePageState();
}

class _CryptoPricePageState extends State<CryptoPricePage> {
  WebSocketChannel? channel;
  String? lastPrice = '';

  @override
  void initState() {
    super.initState();
    // Connect to the Binance WebSocket for real-time Bitcoin price updates
    channel = IOWebSocketChannel.connect(
        'wss://stream.binance.com:9443/ws/btcusdt@ticker');
    // Listen for updates
    channel!.stream.listen((data) {
      final decodedData = jsonDecode(data);
      setState(() {
        lastPrice = decodedData['c']; // 'c' stands for the current price
      });
    });
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Crypto Prices'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BTC/USDT Current Price:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              lastPrice != null
                  ? Text(
                      '\$${lastPrice!}',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
