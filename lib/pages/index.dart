import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import '../controller/index.dart';
import '../models/photo_entity.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
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
  final AutoGenPhotoController _controller = Get.put(AutoGenPhotoController());

  @override
  void initState() {
    super.initState();
    _controller.fetchAutoGenPhotos(); // 初始化时加载数据
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: EasyRefresh(
              controller: _controller.refreshController,
              onRefresh: () async {
                await _controller.fetchAutoGenPhotos();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height, // Full-screen height
                      child: Obx(
                            () => _controller.photoData.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          padding: const EdgeInsets.all(8),
                          itemCount: _controller.photoData.length,
                          itemBuilder: (context, index) {
                            PhotoEntity photo = _controller.photoData[index];
                            return Image.network(
                              photo.img ?? 'https://placehold.co/600x400?text=No+Image',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //child:
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: const Color(0xFFE6D7FF),
            child: Column(
              children: [
                const Text(
                  '点击屏幕开拍',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF8A62CC),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://placehold.co/100x100?description=Logo',
                      width: 30,
                      height: 30,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '乐玩幻镜',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8A62CC),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '乐玩幻境AI写真',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A62CC),
                  ),
                ),
                const Text(
                  '怎么这么好看!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A62CC),
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