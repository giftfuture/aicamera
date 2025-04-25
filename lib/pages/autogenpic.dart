
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/index.dart';
import 'choosemodel.dart';
// Assuming AutoGenPhotoController and its data structure exist
// import '../controller/index.dart';

// Placeholder for the controller and data model for demonstration

// 删除原有的 GetMaterialApp 包裹
class AutoGenPicPage extends StatelessWidget {
  const AutoGenPicPage({super.key});
  @override
  Widget build(BuildContext context) {
    // Ensure your root app widget is GetMaterialApp if using GetX navigation/state management extensively
    return MaterialApp( // Using GetMaterialApp is recommended with GetX
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
      backgroundColor: const Color(0xFFF0F0F7), // Background color for the page
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          // Use Get.back() for navigation if using GetX routes
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFFF0F0F7), // Match scaffold background
        title: const Text(
          '已为您自动生成一张', // AppBar title
          style: TextStyle(color: Colors.black, fontSize: 18), // Title style
        ),
        elevation: 0, // Remove AppBar shadow
        centerTitle: true, // Center the title
        // Removed the actions list which previously contained the Chip
      ),
      body: Row( // Use a Row to place main content and side button
        children: [
          // Expanded takes up the available horizontal space for the main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 16.0, bottom: 16.0), // Adjust padding
              child: Column( // Main content column
                children: [
                  // Top image container
                  Container(
                    clipBehavior: Clip.hardEdge, // Clip the image to the border radius
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners for the image
                    ),
                    child: Image.network(
                      'https://mpas.playinjoy.com/offLine/menu/class-feiyi2.png?x-oss-process=image/format,jpg', // Placeholder image
                      width: double.infinity, // Make image take available width
                      height: MediaQuery.of(context).size.width * 0.7, // Adjust height relative to width
                      fit: BoxFit.cover, // Cover the container space
                      errorBuilder: (context, error, stackTrace) => const Center(child: Text('无法加载图片')), // Error placeholder
                    ),
                  ),
                  const SizedBox(height: 16), // Spacing
                  // Recommendation bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // White background
                      borderRadius: BorderRadius.circular(24.0), // Pill shape
                    ),
                    child: InkWell(
                      onTap: () {
                        // 执行页面跳转
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ChooseModelPage()),
                        );
                      },
                      // 可选：添加点击效果样式
                      splashColor: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0), // 增加点击区域
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.volume_up_rounded, size: 16, color: Colors.deepPurple),
                            SizedBox(width: 8),
                            Text('为您推荐更多可选的类型'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Spacing
                  // Grid view for photo styles
                  Expanded( // Allow GridView to take remaining vertical space
                    child: Obx(() => GridView.count(
                      crossAxisCount: 2, // Two items per row
                      mainAxisSpacing: 16, // Vertical spacing
                      crossAxisSpacing: 16, // Horizontal spacing
                      childAspectRatio: 0.8, // Aspect ratio of grid items
                      // shrinkWrap: true, // Removed shrinkWrap as it's inside an Expanded
                      // physics: const NeverScrollableScrollPhysics(), // Removed physics as it's inside an Expanded
                      children: _controller.photoData.isNotEmpty
                          ? _controller.photoData
                          .map((photo) {
                        // Build each grid item
                        return _buildGridItem(
                          photo.img ?? 'https://placehold.co/150x200?text=Error', // Image URL or placeholder
                          photo.title ?? '加载中...', // Title or loading text
                          // chipText: '选择此风格' // Example chip text if needed later
                        );
                      }).toList()
                          : List.generate(4, (index) => _buildGridItemShimmer()), // Show shimmer if data is empty/loading
                    )),
                  ),
                  // Removed Spacer as GridView is now Expanded
                  const SizedBox(height: 16), // Spacing before bottom logo
                  // Bottom logo row
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.headset_mic_rounded, size: 32, color: Colors.black54), // Logo icon
                      SizedBox(width: 8), // Spacing
                      Text(
                        '乐玩幻镜', // Brand name
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54), // Brand text style
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // --- Vertical "Go to Print" Button ---
          GestureDetector(
            onTap: () {
              // Add navigation logic for printing here
              print("Go to Print Tapped!");
              // Example: Get.toNamed('/print');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0), // Padding inside the button container
              margin: const EdgeInsets.only(right: 8.0), // Margin outside the button
              decoration: BoxDecoration(
                color: const Color(0xFFEA4335), // Red background color matching the old chip
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              child: const Column( // Use Column for vertical arrangement
                mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                children: [
                  // Individual Text widgets for each character
                  Text('前', style: TextStyle(color: Colors.white, fontSize: 14)),
                  SizedBox(height: 4), // Spacing between characters
                  Text('往', style: TextStyle(color: Colors.white, fontSize: 14)),
                  SizedBox(height: 4),
                  Text('打', style: TextStyle(color: Colors.white, fontSize: 14)),
                  SizedBox(height: 4),
                  Text('印', style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build each item in the grid
  Widget _buildGridItem(String imageUrl, String text, {String? chipText}) {
    return GestureDetector(
      onTap: () {
        print("Selected style: $text");
        // Add logic to handle style selection
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // White background for grid item
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          boxShadow: [ // Subtle shadow for depth
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
          children: [
            Expanded( // Image takes up available space
              child: ClipRRect( // Clip image to rounded corners
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.network(
                  imageUrl, // Image URL
                  fit: BoxFit.cover, // Cover the space
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)), // Error placeholder
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Padding for the text/chip row
              child: Row(
                mainAxisAlignment: chipText != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center, // Adjust alignment based on chip presence
                children: [
                  Text(text, style: const TextStyle(fontWeight: FontWeight.w500)), // Style title
                  if (chipText != null) // Conditionally display the chip
                    Chip(
                      backgroundColor: const Color(0xFFEA4335), // Chip background color
                      label: Text(
                        chipText,
                        style: const TextStyle(color: Colors.white, fontSize: 10), // Chip text style
                      ),
                      padding: EdgeInsets.zero, // Adjust chip padding
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0), // Adjust label padding
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap target size
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder shimmer widget for loading state
  Widget _buildGridItemShimmer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300], // Shimmer background
        borderRadius: BorderRadius.circular(8.0),
      ),
      // You can add a shimmer effect package here for animation
    );
  }
}
