import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/index.dart';

class ChoosePrintPage extends StatelessWidget {
  const ChoosePrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.pink,
        useMaterial3: true,
      ),
      home: const PhotoPrintScreen(),
    );
  }
}

class PhotoPrintScreen extends StatefulWidget {
  const PhotoPrintScreen({super.key});

  @override
  State<PhotoPrintScreen> createState() => _PhotoPrintScreenState();
}

class _PhotoPrintScreenState extends State<PhotoPrintScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          // Use Get.back() for navigation if using GetX routes
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFFF0F0F7),
        title: const Text(
          '请选择需要打印的照片',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              '125',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 400,
            child: Stack(
              children: [
                PageView(
                  children: [
                    Image.network(
                      'https://placehold.co/300x400?description=Woman%20in%20traditional%20Chinese%20clothing%20holding%20a%20red%20envelope',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://placehold.co/300x400?description=Woman%20in%20traditional%20Chinese%20clothing',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: Colors.black,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        child: const Icon(Icons.close),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: Colors.black,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        child: const Icon(Icons.check),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '太好看了! 喜欢吗?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.print),
                    Text('打印'),
                    Text('支付39.9元', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.image),
                    Text('电子照'),
                    Text('支付19.9元', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.network(
                    'https://placehold.co/100x100?description=Woman%20in%20traditional%20Chinese%20clothing',
                    fit: BoxFit.cover,
                  ),
                  const Text('已选'),
                ],
              ),
              Column(
                children: [
                  Image.network(
                    'https://placehold.co/100x100?description=Two%20women',
                    fit: BoxFit.cover,
                  ),
                  const Text('已选'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
