import 'dart:async'; // Import the async library for Timer
import 'package:aicamera/pages/autogenpic.dart';
import 'package:aicamera/pages/choosemodel.dart';
import 'package:flutter/material.dart';

// Main application class
class TakePhotoPage extends StatelessWidget {
  const TakePhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: ThemeData(
        colorSchemeSeed: Colors.purple, // Base color for the theme
        useMaterial3: true, // Enables Material 3 design features
      ),
       home: const MyHomePage(), // 'home' is replaced by 'initialRoute' and 'routes'
    );
  }
}

// Stateful widget for the home page (Photo Taking)
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State class for the home page
class _MyHomePageState extends State<MyHomePage> {
  // Timer object for the countdown
  Timer? _timer;
  // State variable to hold the remaining seconds
  int _remainingSeconds = 8;

  // Called when the widget is inserted into the widget tree
  @override
  void initState() {
    super.initState();
    _startTimer(); // Start the countdown timer when the widget initializes
  }

  // Called when the widget is removed from the widget tree
  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  // Function to start the countdown timer
  void _startTimer() {
    // Create a periodic timer that fires every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Check if the countdown is still running
      if (_remainingSeconds > 0) {
        // Use setState to trigger a UI rebuild with the updated time
        if (mounted) { // Check if the widget is still in the tree
          setState(() {
            _remainingSeconds--; // Decrement the remaining seconds
          });
        } else {
          timer.cancel(); // Cancel timer if widget is disposed during callback
        }
      } else {
        _timer?.cancel(); // Stop the timer when it reaches 0
        // Optional: Add logic here for what happens when the timer finishes
        print("Countdown finished!");
        // Example: Automatically navigate when timer ends
        // if (mounted) {
        //   Navigator.pushNamed(context, '/choosemodel');
        // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using SafeArea to avoid intrusions by system UI (like notches)
      body: SafeArea(
        // Adding padding around the main content
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Uniform padding
          // Using a Row to arrange elements horizontally
          child: Row(
            // Distributes space: pushes first and last children to edges, centers middle child
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, // Center items vertically
            children: [
              // --- Left Column: Vertical Text ---
              const Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                // List of Text widgets forming the vertical message
                children: [
                  Text('请'),
                  Text('正'),
                  Text('对'),
                  Text('镜'),
                  Text('子'),
                  Text('拍'),
                  Text('照'),
                ],
              ),

              // --- Center Column: Image and Action Buttons ---
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                children: <Widget>[
                  // Stack for layering the image and overlay
                  Stack(
                    alignment: Alignment.center, // Center items in the stack
                    children: [
                      // Background container with gradient
                      Container(
                        width: 300,
                        height: 450,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE6E6FA), // Light lavender color
                              Colors.white,
                            ],
                          ),
                        ),
                      ),
                      // Image placeholder
                      ClipRRect( // Clip the image to rounded corners
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          'https://placehold.co/300x400?text=Placeholder+Image', // Placeholder image URL
                          width: 300,
                          height: 400,
                          fit: BoxFit.cover, // Cover the area
                          // Error handling for the image
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 300,
                              height: 400,
                              color: Colors.grey[300],
                              child: const Center(child: Text('Image failed to load')),
                            );
                          },
                        ),
                      ),
                      // Border overlay (optional, for visual separation)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 400, // Match image height
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      // Bottom overlay with countdown timer
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.black, // Black background
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              // Display the remaining seconds
                              _remainingSeconds.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Spacing
                  // Row for 'Next' and 'Retake' buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center buttons horizontally
                    children: [
                      // 'Next' button - Navigates to /choosemodel
                      ElevatedButton.icon(
                      onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AutoGenPicPage()),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('下一步'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan, // Button color
                          foregroundColor: Colors.white, // Text/icon color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                      const SizedBox(width: 20), // Spacing between buttons
                      // 'Retake' button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Reset timer on retake
                          _timer?.cancel();
                          // Check if mounted before calling setState
                          if(mounted) {
                            setState(() {
                              _remainingSeconds = 8;
                            });
                          }
                          _startTimer();
                          /* Add other retake logic */
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('重拍'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink, // Button color
                          foregroundColor: Colors.white, // Text/icon color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // --- Right Column: Mirror Controls ---
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                children: [
                  // 'Mirror Up' button
                  InkWell( // Makes the container tappable
                    onTap: () { /* Add mirror up logic */ },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent, // Button color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_upward, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 5), // Small spacing
                  const Text('镜子上升'), // Label for the button
                  const SizedBox(height: 20), // Spacing between controls
                  // 'Mirror Down' button
                  InkWell( // Makes the container tappable
                    onTap: () { /* Add mirror down logic */ },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent, // Button color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_downward, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 5), // Small spacing
                  const Text('镜子下降'), // Label for the button
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


