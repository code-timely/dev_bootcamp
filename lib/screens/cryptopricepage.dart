import 'dart:convert';
import 'package:dev_bootcamp/components/cryptocard.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final log = Logger();

class CryptoPricePage extends StatefulWidget {
  const CryptoPricePage({super.key});

  @override
  State<CryptoPricePage> createState() => _CryptoPricePageState();
}

class _CryptoPricePageState extends State<CryptoPricePage> {
  WebSocketChannel? btcChannel;
  WebSocketChannel? ethChannel;
  WebSocketChannel? bnbChannel;
  String? btcPrice = '';
  String? ethPrice = '';
  String? bnbPrice = '';

  @override
  void initState() {
    super.initState();

    btcChannel = IOWebSocketChannel.connect(
        'wss://stream.binance.com:9443/ws/btcusdt@ticker');
    btcChannel!.stream.listen((data) {
      final decodedData = jsonDecode(data);
      setState(() {
        btcPrice = decodedData['c'];
      });
    });

    ethChannel = IOWebSocketChannel.connect(
        'wss://stream.binance.com:9443/ws/ethusdt@ticker');
    ethChannel!.stream.listen((data) {
      final decodedData = jsonDecode(data);
      setState(() {
        ethPrice = decodedData['c'];
      });
    });

    bnbChannel = IOWebSocketChannel.connect(
        'wss://stream.binance.com:9443/ws/bnbusdt@ticker');
    bnbChannel!.stream.listen((data) {
      final decodedData = jsonDecode(data);
      setState(() {
        bnbPrice = decodedData['c'];
      });
    });
  }

  @override
  void dispose() {
    btcChannel?.sink.close();
    ethChannel?.sink.close();
    bnbChannel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Prices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cryptoCard('BTC/USDT', btcPrice),
              const SizedBox(height: 10),
              cryptoCard('ETH/USDT', ethPrice),
              const SizedBox(height: 10),
              cryptoCard('BNB/USDT', bnbPrice),
            ],
          ),
        ),
      ),
    );
  }
}
