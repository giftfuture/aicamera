import 'package:flutter/material.dart';



class ModelCategoryPage extends StatelessWidget {
  const ModelCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E2FF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF6F2FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new_rounded),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '担心隐私泄露?别担心!',
                        style: TextStyle(
                          color: Color(0xFFEF5350),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '本次拍摄照片仅用于换装生成生成后所有照片资料将即刻自动销毁,不留痕迹确保您的个人信息得到最严格的保护。',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: [
                  _GridItem(
                    image:
                    'https://placehold.co/200x200?description=A%20woman%20in%20traditional%20Chinese%20clothing%20holding%20a%20butterfly',
                    title: '豫园三十周年',
                  ),
                  _GridItem(
                    image:
                    'https://placehold.co/200x200?description=A%20woman%20in%20a%20black%20dress',
                    title: 'AI换衣',
                  ),
                  _GridItem(
                    image:
                    'https://placehold.co/200x200?description=A%20man%20in%20a%20suit',
                    title: '证件照',
                  ),
                  _GridItem(
                    image:
                    'https://placehold.co/200x200?description=A%20collage%20of%20four%20women%20with%20different%20hairstyles',
                    title: '风格照',
                    badge: '极速',
                  ),
                  _GridItem(
                    image:
                    'https://placehold.co/200x200?description=A%20couple%20posing%20for%20a%20photo',
                    title: '双人照',
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF8E24AA),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  const Text(
                    '乐玩幻镜',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Text(
                      '125',
                      style: TextStyle(
                        color: Color(0xFF8E24AA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final String image;
  final String title;
  final String? badge;

  const _GridItem({
    required this.image,
    required this.title,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF5350),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
