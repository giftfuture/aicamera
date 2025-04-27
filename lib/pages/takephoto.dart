import 'dart:async'; // Import the async library for Timer
import 'package:aicamera/pages/autogenpic.dart';
// import 'package:aicamera/pages/choosemodel.dart'; // Not used in this file directly
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Import the camera package

// Main application class (StatelessWidget)
class TakePhotoPage extends StatelessWidget {
  const TakePhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      home: const MyHomePage(), // Set the home page
    );
  }
}

// Stateful widget for the photo taking page
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State class for the photo taking page
class _MyHomePageState extends State<MyHomePage> {
  // Timer variables
  Timer? _timer;
  int _remainingSeconds = 8;

  // --- Camera Controller Variables ---
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? cameras;
  CameraDescription? _selectedCamera; // To store the chosen camera
  bool _isCameraInitializing = false; // Flag to track initialization state

  @override
  void initState() {
    super.initState();
    // Start the countdown timer
    _startTimer();
    // --- Initialize Camera ---
    _initializeCamera();
  }

  @override
  void dispose() {
    // Cancel the timer
    _timer?.cancel();
    // --- Dispose camera controller ---
    // Use ?.dispose() for safety as it might be null during initialization errors
    print("Disposing camera controller in State dispose()...");
    _cameraController?.dispose();
    print("Camera controller disposal called.");
    super.dispose();
  }

  // --- Function to initialize camera ---
  Future<void> _initializeCamera() async {
    // Prevent multiple initializations running concurrently
    if (_isCameraInitializing) {
      print("Camera initialization already in progress. Skipping.");
      return;
    }

    print("Attempting to initialize camera...");
    // Ensure UI updates to show loading state immediately on retake
    if (mounted) {
      setState(() {
        _isCameraInitializing = true;
        // Set future to null/error to show loading indicator immediately on retake
        _initializeControllerFuture = null;
      });
    }


    try {
      // --- Dispose previous controller if exists ---
      print("Disposing previous camera controller (if any)...");
      // Store the dispose future to ensure it completes.
      Future<void>? disposeFuture = _cameraController?.dispose();
      _cameraController = null; // Set to null immediately
      await disposeFuture; // Wait for disposal to complete
      print("Previous controller disposed.");

      // --- Add a short delay ---
      print("Adding short delay before getting cameras...");
      await Future.delayed(const Duration(milliseconds: 150)); // Wait 150ms
      print("Delay finished.");


      // --- Get available cameras ---
      print("Getting available cameras...");
      cameras = await availableCameras();
      print("Available cameras result: $cameras"); // Log the result

      // --- Check if cameras list is null or empty ---
      if (cameras == null || cameras!.isEmpty) {
        print("Error: No cameras found on this device.");
        throw Exception("No cameras available"); // Throw specific exception
      }
      print("Found ${cameras!.length} cameras.");

      // --- Select Front Camera if available ---
      print("Attempting to select front camera...");
      _selectedCamera = cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () {
          print("Front camera not found, falling back to the first camera.");
          return cameras!.first; // Fallback to the first camera (usually back)
        },
      );
      print("Selected camera: ${_selectedCamera?.name} (Lens: ${_selectedCamera?.lensDirection})");

      // --- Create CameraController ---
      print("Creating CameraController...");
      _cameraController = CameraController(
        _selectedCamera!,
        ResolutionPreset.high,
        enableAudio: false,
        // imageFormatGroup: ImageFormatGroup.yuv420, // Consider if needed for Android
      );
      print("CameraController created.");

      // --- Initialize CameraController ---
      print("Initializing CameraController...");
      // Store the initialization future
      final initFuture = _cameraController!.initialize();
      // Assign future *after* creation to ensure FutureBuilder gets the correct one
      if (mounted) {
        setState(() {
          _initializeControllerFuture = initFuture;
        });
      }

      // Wait for initialization to complete (important!)
      await initFuture;
      print("CameraController initialized successfully.");

    } catch (e) {
      print("Error during camera initialization: $e"); // Log the specific error
      // Store the error in the future so FutureBuilder can display it
      if (mounted) {
        setState(() {
          _initializeControllerFuture = Future.error(e);
        });
      }
    } finally {
      // Update UI regardless of success or failure, reset flag
      print("Camera initialization process finished.");
      if (mounted) {
        setState(() {
          _isCameraInitializing = false;
        });
      }
    }
  }


  // Function to start the countdown timer
  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _remainingSeconds = 8; // Reset seconds
    if(mounted) setState(() {}); // Update UI immediately to show initial time

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          timer.cancel(); // Ensure timer stops if widget is disposed
        }
      } else {
        _timer?.cancel();
        print("Countdown finished!");
        // --- Take picture when timer finishes ---
        _takePicture(); // Call the take picture function
      }
    });
  }

  // --- Function to handle retake ---
  void _handleRetake() {
    print("Retake button pressed. Re-initializing camera and timer...");
    // Restart the timer
    _startTimer();
    // Re-initialize the camera
    // No need to await here, FutureBuilder will handle the loading state
    _initializeCamera();
  }

  // --- Function for taking picture logic ---
  Future<void> _takePicture() async {
    print("Attempting to take picture...");
    // Ensure controller is initialized and not already taking a picture
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Error: Camera controller is not initialized.');
      // Optionally show a message to the user
      // if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('相机未准备好')));
      return;
    }
    if (_cameraController!.value.isTakingPicture) {
      print('Error: Already taking picture.');
      return;
    }

    try {
      // Attempt to take a picture and get the file `XFile` where it was saved.
      print("Calling takePicture()...");
      final XFile imageFile = await _cameraController!.takePicture();
      print('Picture saved to ${imageFile.path}');

      // --- Navigate after taking picture ---
      // You might want to pass the image path to the next screen
      // --- MODIFICATION: Added check and log before navigation ---
      if (mounted) {
        print("Checking if mounted before navigation: true");
        print("Navigating to AutoGenPicPage with image path: ${imageFile.path}");
        // Ensure AutoGenPicPage constructor can handle the parameter if you pass it
        // Example: MaterialPageRoute(builder: (context) => AutoGenPicPage(imagePath: imageFile.path)),
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AutoGenPicPage()),
        );
        print("Navigator.push called."); // Log after calling push
      } else {
        print("Checking if mounted before navigation: false. Navigation skipped.");
      }
      // --- End Modification ---
    } catch (e) {
      // If an error occurs, log the error to the console.
      print('Error taking picture: $e');
      // Optionally show a message to the user
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('拍照失败: $e')));
      // }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Left Column: Vertical Text ---
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('请'), // Please
                  Text('正'), // Directly
                  Text('对'), // Face
                  Text('镜'), // Mirror
                  Text('子'), // (Particle)
                  Text('拍'), // Take
                  Text('照'), // Photo
                ],
              ),

              // --- Center Column: Camera Preview and Action Buttons ---
              Expanded( // Allow center column to take available space if needed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Stack for layering the camera preview and overlay
                    SizedBox( // Constrain the size of the Stack/Preview area
                      width: 300, // Maintain original width
                      height: 450, // Maintain original height
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // --- Camera Preview Area ---
                          Positioned.fill( // Position preview to fill the container
                            child: Container(
                              clipBehavior: Clip.hardEdge, // Clip the preview
                              decoration: BoxDecoration(
                                color: Colors.black, // Background while loading
                                borderRadius: BorderRadius.circular(20), // Rounded corners for the whole box
                              ),
                              // Use FutureBuilder to handle camera initialization state
                              child: FutureBuilder<void>(
                                future: _initializeControllerFuture,
                                builder: (context, snapshot) {
                                  // Check connection state first
                                  if (snapshot.connectionState == ConnectionState.waiting || _isCameraInitializing) {
                                    // Show loading indicator while waiting or explicitly initializing
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    // Show error message if initialization failed
                                    print("FutureBuilder: Error initializing camera - ${snapshot.error}");
                                    return Center(child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('无法初始化相机:\n${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                                    ));
                                  } else if (_cameraController != null && _cameraController!.value.isInitialized) {
                                    // --- Display Camera Preview if initialized successfully ---
                                    return FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        // Swap dimensions because camera preview is often landscape,
                                        // but we want to fit it into a portrait container.
                                        width: _cameraController!.value.previewSize!.height,
                                        height: _cameraController!.value.previewSize!.width,
                                        child: CameraPreview(_cameraController!),
                                      ),
                                    );
                                  } else {
                                    // Fallback case
                                    print("FutureBuilder: Unknown camera state after future completion.");
                                    return const Center(child: Text('相机状态未知', style: TextStyle(color: Colors.white))); // Unknown camera state
                                  }
                                },
                              ),
                            ),
                          ),

                          // --- Bottom Timer Overlay ---
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 50, // Height of the timer bar
                              decoration: const BoxDecoration(
                                color: Colors.black54, // Semi-transparent black
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _remainingSeconds.toString(), // Display countdown
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
                    ),
                    const SizedBox(height: 20), // Spacing

                    // --- Action Buttons ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 'Next' button
                        ElevatedButton.icon(
                          onPressed: () {
                            // --- Take picture on 'Next' button press ---
                            _takePicture(); // Call take picture function
                            // Note: Navigation happens inside _takePicture after success
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('下一步'), // Next Step
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // 'Retake' button
                        ElevatedButton.icon(
                          onPressed: _handleRetake, // Call the handler function
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('重拍'), // Retake
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Right Column: Mirror Controls ---
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () { /* TODO: Add mirror up logic */ },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.arrow_upward, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text('镜子上升'), // Mirror Up
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () { /* TODO: Add mirror down logic */ },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.arrow_downward, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text('镜子下降'), // Mirror Down
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
