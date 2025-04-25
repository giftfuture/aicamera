import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import '../controller/index.dart';
import '../models/logo_entity.dart';
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
    _controller.fetchLogo();
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
                // Fetch the logo when the list is refreshed
                await _controller.fetchLogo();
                // Optionally, you may want to refresh the photos as well
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
                            : Padding(
                          padding: const EdgeInsets.all(8.0), // 页面边缘间距
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final screenWidth = constraints.maxWidth;
                              const spacing = 8.0;

                              // 第一行：2张图片
                              final firstRowImageWidth = (screenWidth - 3 * spacing) / 2;
                              final firstRowImageHeight = firstRowImageWidth * 3 / 2;

                              // 第二行：3张图片
                              final secondRowImageWidth = (screenWidth - 4 * spacing) / 3;
                              final secondRowImageHeight = secondRowImageWidth * 3 / 2;

                              // 第四行：1张图片（第六张）
                              final fourthRowImageWidth = screenWidth; // 整行宽度
                              final fourthRowImageHeight = fourthRowImageWidth * 3 / 2;

                              return _controller.photoData.length < 6
                                  ? const Center(child: Text('图片数量不足'))
                                  : SingleChildScrollView( // Wrap in SingleChildScrollView
                                child: Column(
                                  children: [
                                    // 第一行：2张图片
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildImageWidget(_controller.photoData[0], firstRowImageWidth, firstRowImageHeight),
                                        SizedBox(width: spacing),
                                        _buildImageWidget(_controller.photoData[1], firstRowImageWidth, firstRowImageHeight),
                                      ],
                                    ),
                                    SizedBox(height: spacing),
                                    // 第二行：3张图片
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildImageWidget(_controller.photoData[2], secondRowImageWidth, secondRowImageHeight),
                                        SizedBox(width: spacing),
                                        _buildImageWidget(_controller.photoData[3], secondRowImageWidth, secondRowImageHeight),
                                        SizedBox(width: spacing),
                                        _buildImageWidget(_controller.photoData[4], secondRowImageWidth, secondRowImageHeight),
                                      ],
                                    ),
                                    SizedBox(height: spacing),
                                    // 第三行："点击屏幕开拍"按钮
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      color: const Color(0xFFE6D7FF),
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.toNamed('/takephoto');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            child: const Text(
                                              '-点击屏幕开拍-',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF8A62CC),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: spacing),
                                    // 第四行：第六张图片 (with logo overlay)
                                    Stack(
                                      children: [
                                        // Reference image
                                        _controller.photoData.length > 5
                                            ? _buildImageWidget(_controller.photoData[5], fourthRowImageWidth, fourthRowImageHeight)
                                            : const SizedBox(),
                                        // Logo image overlay
                                        FutureBuilder<LogoEntity?>(
                                          future: _controller.fetchLogo(),
                                          builder: (context, snapshot) {
                                            print('snapshot.data: ${snapshot.data}, type: ${snapshot.data?.runtimeType}');
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const SizedBox();
                                            } else if (snapshot.hasError) {
                                              print('Error: ${snapshot.error}');
                                              return const Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Icon(Icons.error, size: 20),
                                              );
                                            } else if (snapshot.hasData && snapshot.data != null) {
                                              final logoEntity = snapshot.data!;
                                              final logoUrl = logoEntity.logoUrl ?? 'https://example.com/default.png';
                                              print("logoUrl=$logoUrl");
                                              print('Reference image dimensions: $fourthRowImageWidth x $fourthRowImageHeight');
                                              print('Logo image dimensions: ${fourthRowImageWidth / 3} x ${fourthRowImageHeight / 3}');
                                              return Positioned(
                                                top: -70,
                                                left: 10,
                                                // top: 0,
                                                // left: 0,
                                                child: Image.network(
                                                  logoUrl,
                                                  width: fourthRowImageWidth / 3,
                                                  height: fourthRowImageHeight / 3,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 20),
                                                ),
                                              );
                                            } else {
                                              print('No data received from fetchLogo');
                                              return const SizedBox();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// 辅助方法：构建图片 widget
Widget _buildImageWidget(PhotoEntity photo, double width, double height) {
  return Container(
    width: width,
    height: height,
    child: Image.network(
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
    ),
  );
}