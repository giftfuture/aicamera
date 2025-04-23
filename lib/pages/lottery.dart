import 'package:flutter/material.dart';



class LotteryPage extends StatelessWidget {
  const LotteryPage({super.key});

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
      backgroundColor: const Color(0xFF673AB7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    '当前剩余可体验风格照：',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '2张',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(16.0),
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildGridItem(
                      '疯狂动物城',
                      'https://placehold.co/150x150?description=Crazy%20Animal%20City%20style%20image',
                      1),
                  _buildGridItem(
                      '利希滕斯坦',
                      'https://placehold.co/150x150?description=Lichtenstein%20style%20image',
                      null),
                  _buildGridItem(
                      '暗光',
                      'https://placehold.co/150x150?description=Dark%20style%20image',
                      null),
                  _buildGridItem(
                      '剪纸',
                      'https://placehold.co/150x150?description=Paper-cut%20style%20image',
                      null),
                  _buildGridItem(
                      '詹姆斯',
                      'https://placehold.co/150x150?description=James%20style%20image',
                      2),
                  _buildGridItem(
                      '冰雪女王',
                      'https://placehold.co/150x150?description=Ice%20Queen%20style%20image',
                      null),
                  _buildGridItem(
                      '赛博朋克',
                      'https://placehold.co/150x150?description=Cyberpunk%20style%20image',
                      null),
                  _buildGridItem(
                      '乔治亚',
                      'https://placehold.co/150x150?description=Georgia%20style%20image',
                      null),
                  _buildGridItem(
                      '正式',
                      'https://placehold.co/150x150?description=Formal%20style%20image',
                      null),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.print, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      '前往打印',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String text, String imageUrl, int? number) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            if (number != null)
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFE91E63),
                  radius: 16,
                  child: Text(
                    number.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
