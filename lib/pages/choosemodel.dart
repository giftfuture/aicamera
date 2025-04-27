import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get if using GetX navigation

// --- IMPORT ChoosePrintPage ---
// Make sure you have this page defined and import it correctly.
import 'chooseprint.dart'; // Assuming the file is named chooseprint.dart

class ChooseModelPage extends StatelessWidget {
  const ChooseModelPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MaterialApp here might cause issues if this isn't the root widget.
    return const MyHomePage(); // Directly return MyHomePage
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
    // Define the print button widget separately for clarity
    Widget printButton = GestureDetector(
      onTap: () {
        // Navigation logic for printing
        print("前往打印 tapped from ChooseModelPage!"); // Log for debugging
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChoosePrintPage()), // Navigates to ChoosePrintPage
        );
        // Or using GetX:
        // Get.to(() => const ChoosePrintPage());
      },
      child: Container(
        // Adjust padding and margin for placement on the left
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        // Removed top margin for better vertical centering
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFEA4335), // Red background color
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: const Column( // Vertical text arrangement
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Take minimum vertical space
          children: [
            Text('前', style: TextStyle(color: Colors.white, fontSize: 14)), // "Go"
            SizedBox(height: 4),
            Text('往', style: TextStyle(color: Colors.white, fontSize: 14)), // "To"
            SizedBox(height: 4),
            Text('打', style: TextStyle(color: Colors.white, fontSize: 14)), // "Print"
            SizedBox(height: 4),
            Text('印', style: TextStyle(color: Colors.white, fontSize: 14)), // (Character for print)
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE9E2FF),
      body: SafeArea(
        // Use a Row to place the button on the left and content on the right
        child: Row(
          // --- MODIFICATION: Center items vertically ---
          crossAxisAlignment: CrossAxisAlignment.center, // Align button and content vertically center
          children: [
            // --- Inserted Print Button ---
            printButton,

            // --- Original Content (Wrapped in Expanded) ---
            Expanded(
              child: Column( // Original main content column
                children: [
                  // Top bar with back button, text, counter etc.
                  Padding(
                    // Added top padding back here since it's inside the Column
                    padding: const EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0),
                    child: Row(
                      children: [
                        // IconButton for back navigation
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () => Navigator.of(context).pop(), // Or Get.back()
                        ),
                        const Text(
                          '当前剩余可体验照片:', // "Currently remaining trial photos:"
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            '2张', // "2 photos"
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Spacer(), // Pushes the avatar to the right
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF8A74FF),
                          child: Text(
                            '125', // Example number
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Main image display area
                  Expanded( // Make the image area take available vertical space
                    child: Stack(
                      alignment: Alignment.center, // Center stack children
                      children: [
                        // Image container
                        Padding(
                          // Adjust padding to account for the button on the left
                          padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://placehold.co/300x400?description=A%20woman%20in%20traditional%20Chinese%20clothing%20holding%20a%20red%20envelope',
                              fit: BoxFit.contain, // Use contain or cover based on need
                              // Add loading/error builders for robustness
                              loadingBuilder: (context, child, progress) {
                                return progress == null ? child : const Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) => const Center(child: Text('无法加载图片')), // "Cannot load image"
                            ),
                          ),
                        ),
                        // Number indicator (Top-Left of the image area)
                        Positioned(
                          left: 0, // Position relative to the Padding
                          top: 0,  // Position relative to the Padding
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF8A74FF),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16), // Match image corner
                              ),
                            ),
                            child: const Text(
                              '1', // Example number
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        // "Select Photo" button (Bottom-Center of the image area)
                        Positioned(
                          bottom: 24, // Spacing from the bottom edge
                          child: ElevatedButton(
                            onPressed: () {
                              print("选择照片 button pressed"); // "Select Photo button pressed"
                              // Add action for selecting photo
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Adjust padding
                            ),
                            child: const Text(
                              '点击选择照片', // "Click to select photo"
                              style: TextStyle(color: Colors.black, fontSize: 16), // Adjust style
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16), // Spacing before thumbnails
                  // Thumbnail row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute thumbnails evenly
                      children: [
                        _buildThumbnail(
                            'https://placehold.co/100x100?description=A%20woman%20in%20traditional%20Chinese%20clothing%20holding%20a%20lantern'),
                        _buildThumbnail(
                            'https://placehold.co/100x100?description=A%20woman%20in%20traditional%20Chinese%20clothing%20holding%20a%20red%20envelope'),
                        _buildThumbnail(
                            'https://placehold.co/100x100?description=A%20woman%20in%20traditional%20Chinese%20clothing%20holding%20a%20lantern'),
                        _buildThumbnail(
                            'https://placehold.co/100x100?description=A%20woman%20in%20traditional%20Chinese%20clothing'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16), // Bottom spacing
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build thumbnails
  Widget _buildThumbnail(String imageUrl) {
    // Make thumbnails tappable if needed
    return GestureDetector(
      onTap: () {
        print("Thumbnail tapped: $imageUrl");
        // Add logic to change the main image or select the model
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 80, // Adjust size as needed
          height: 100, // Adjust size as needed
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 80, height: 100, color: Colors.grey[300],
            child: const Icon(Icons.error, size: 24, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
