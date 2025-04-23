import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../controller/index.dart';
import '../models/photo_entity.dart';
import '../models/carousel_req.dart';
import '../repository/index.dart';
import '../utils/dialog_util.dart';

class AutoGenPicPage extends StatelessWidget {
  const AutoGenPicPage({super.key});

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
  final AutoGenPhotoController _controller = Get.put(AutoGenPhotoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F7),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {},
        ),
        backgroundColor: const Color(0xFFF0F0F7),
        title: const Text(
          '已为您自动生成一张',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Chip(
              backgroundColor: Color(0xFFEA4335),
              label: Text(
                '前往打印',
                style: TextStyle(color: Colors.white),
              ),
              labelStyle: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.network(
                'https://placehold.co/350x350?description=A%20colorful%20image%20of%20a%20woman%20with%20short%20hair',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: const Row(
                children: [
                  Icon(Icons.volume_up_rounded, size: 16),
                  SizedBox(width: 8),
                  Text('为您推荐更多可选的类型'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: _controller.photoData.isNotEmpty
                  ? _controller.photoData
                  .asMap()
                  .entries
                  .map((entry) {
                final photo = entry.value;
                return _buildGridItem(
                  photo.img ?? 'https://placehold.co/150x200?description=Placeholder' ,
                  // photo.title ?? '未知类型',
                   chipText:'加载中...'
                );
              }).toList()
                  : [

              ],
            )),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.headset_mic_rounded, size: 48, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  '乐玩幻镜',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String imageUrl,   {String? chipText}) { //, String text,
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(text),
                if (chipText != null)
                  Chip(
                    backgroundColor: const Color(0xFFEA4335),
                    label: Text(
                      chipText,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
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