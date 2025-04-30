import 'dart:async'; // 导入 async 库以使用 Timer
import 'dart:io'; // 导入 dart:io 以使用 File
import 'dart:math' as math; // Import math for max calculation

// --- 导入 UploadController 和 UploadEntity ---
// Make sure these paths are correct for your project structure
// 确保这些路径对于您的项目结构是正确的
import 'package:aicamera/controller/upload.dart'; // Controller for handling uploads / 处理上传的控制器
import 'package:aicamera/models/upload_entity.dart'; // Data model for upload metadata / 上传元数据的数据模型
// --- 结束导入 ---
import 'package:aicamera/pages/autogenpic.dart'; // Page to navigate to after upload / 上传后导航到的页面
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // *** Import for SystemChrome / 导入用于 SystemChrome ***
import 'package:camera/camera.dart'; // 导入 camera 包
import 'package:get/get.dart'; // 导入 GetX 用于控制器管理

// Main application class (StatelessWidget)
// 主要的应用类 (StatelessWidget)
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
      home: const MyHomePage(), // Set the home page / 设置主页
    );
  }
}

// Stateful widget for the photo taking page
// 用于拍照页面的 StatefulWidget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State class for the photo taking page
// 拍照页面的 State 类
class _MyHomePageState extends State<MyHomePage> {
  // Timer variables / 定时器变量
  Timer? _timer;
  int _remainingSeconds = 8; // Countdown duration / 倒计时时长

  // --- Camera Controller Variables / 相机控制器变量 ---
  CameraController? _cameraController;
  // --- Upload Controller Instance / 上传控制器实例 ---
  // Use Get.put to ensure the controller is available, or Get.find if already registered elsewhere.
  // 使用 Get.put 确保控制器可用，如果已在别处注册，则使用 Get.find。
  final UploadController _uploadController = Get.put(UploadController());

  Future<void>? _initializeControllerFuture; // Future for camera initialization / 用于相机初始化的 Future
  List<CameraDescription>? cameras; // List of available cameras / 可用相机列表
  CameraDescription? _selectedCamera; // The camera selected for use / 选择使用的相机
  bool _isCameraInitializing = false; // Flag to track initialization state / 跟踪初始化状态的标志

  @override
  void initState() {
    super.initState();
    // *** Lock orientation to portrait mode when entering the page ***
    // *** 进入页面时将方向锁定为竖屏模式 ***
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _startTimer(); // Start the countdown timer / 启动倒计时
    _initializeCamera(); // Initialize the camera / 初始化相机
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer / 取消定时器
    print("Disposing camera controller in State dispose()...");
    // It's safer to call dispose without awaiting in the State's dispose method
    // 在 State 的 dispose 方法中调用 dispose 而不等待是更安全的
    _cameraController?.dispose().catchError((e) {
      print("Error disposing camera controller: $e"); // Log error during disposal / 记录处理过程中的错误
    });
    print("Camera controller disposal called.");

    // *** Reset preferred orientations when leaving the page ***
    // *** 离开页面时重置首选方向 ***
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  // --- Function to initialize camera / 初始化相机函数 ---
  Future<void> _initializeCamera() async {
    // Prevent multiple initializations running concurrently
    // 防止多个初始化同时运行
    if (_isCameraInitializing) {
      print("Camera initialization already in progress. Skipping.");
      return;
    }

    print("Attempting to initialize camera...");
    // Ensure UI updates to show loading state immediately, especially on retake
    // 确保 UI 立即更新以显示加载状态，尤其是在重拍时
    if (mounted) {
      setState(() {
        _isCameraInitializing = true;
        _initializeControllerFuture = null; // Reset future to show loading indicator / 重置 future 以显示加载指示器
      });
    }

    try {
      // --- Dispose previous controller if exists ---
      // --- 如果存在，则处理先前的控制器 ---
      if (_cameraController != null) {
        print("Disposing previous camera controller...");
        await _cameraController!.dispose(); // Wait for disposal to complete / 等待处理完成
        _cameraController = null; // Set to null after disposal / 处理后设为 null
        print("Previous controller disposed.");
        // Add a small delay AFTER disposing before getting cameras again
        // 在处理完之后、再次获取相机之前添加短暂延迟
        await Future.delayed(const Duration(milliseconds: 100));
      }


      // --- Get available cameras / 获取可用相机 ---
      print("Getting available cameras...");
      cameras = await availableCameras();
      print("Available cameras result: $cameras"); // Log the result / 记录结果

      // --- Check if cameras list is null or empty / 检查相机列表是否为 null 或空 ---
      if (cameras == null || cameras!.isEmpty) {
        print("Error: No cameras found on this device.");
        // Use CameraException for camera-specific errors
        // 对相机特定错误使用 CameraException
        throw CameraException("CAM001", "No cameras available");
      }
      print("Found ${cameras!.length} cameras.");

      // --- Select Front Camera if available / 如果可用，选择前置摄像头 ---
      print("Attempting to select front camera...");
      _selectedCamera = cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front, // Prefer front camera / 优先选择前置摄像头
        orElse: () {
          print("Front camera not found, falling back to the first camera.");
          return cameras!.first; // Fallback to the first camera (usually back) / 回退到第一个相机（通常是后置）
        },
      );
      print("Selected camera: ${_selectedCamera?.name} (Lens: ${_selectedCamera?.lensDirection})");

      // --- Create CameraController / 创建 CameraController ---
      print("Creating CameraController...");
      // Assign to a local variable first to ensure atomicity
      // 首先分配给局部变量以确保原子性
      final newController = CameraController(
        _selectedCamera!,
        // Use max resolution as requested previously
        // 根据之前的请求使用最大分辨率
        ResolutionPreset.max,
        enableAudio: false, // Disable audio recording / 禁用音频录制
        // *** Explicitly set image format group if needed, usually defaults are fine ***
        // *** 如果需要，明确设置图像格式组，通常默认值即可 ***
        // imageFormatGroup: ImageFormatGroup.jpeg,
      );
      print("CameraController created with ResolutionPreset.max.");

      // --- Initialize CameraController / 初始化 CameraController ---
      print("Initializing CameraController...");
      // Store the initialization future locally
      // 在本地存储初始化 future
      final initFuture = newController.initialize();

      // Update state ONLY if mounted to avoid errors after dispose
      // 仅在挂载时更新状态，以避免 dispose 后出错
      if (mounted) {
        setState(() {
          // Assign the controller and future only after creation/init starts
          // 仅在创建/初始化开始后分配控制器和 future
          _cameraController = newController;
          _initializeControllerFuture = initFuture;
        });
      }

      // Await initialization AFTER setting state (if mounted)
      // 在设置状态之后（如果已挂载）等待初始化
      await initFuture;
      print("CameraController initialized successfully.");

      // *** Optional: Lock camera orientation after initialization (if needed) ***
      // *** 可选：初始化后锁定相机方向（如果需要）***
      // Note: This might conflict with device rotation handling or might not be supported by all devices/cameras.
      // 注意：这可能与设备旋转处理冲突，或者并非所有设备/相机都支持。
      // try {
      //   await _cameraController?.lockCaptureOrientation(DeviceOrientation.portraitUp);
      //   print("Camera capture orientation locked to portraitUp.");
      // } catch (e) {
      //   print("Could not lock camera orientation: $e");
      // }


    } on CameraException catch (e) {
      // Handle camera-specific exceptions
      // 处理相机特定的异常
      print("CameraException during camera initialization: ${e.code} - ${e.description}");
      if (mounted) {
        setState(() {
          // Store the error in the future so the FutureBuilder can display it
          // 将错误存储在 future 中，以便 FutureBuilder 可以显示它
          _initializeControllerFuture = Future.error(e);
        });
      }
    } catch (e) {
      // Handle other generic errors during initialization
      // 处理初始化期间的其他通用错误
      print("Generic error during camera initialization: $e");
      if (mounted) {
        setState(() {
          _initializeControllerFuture = Future.error(e);
        });
      }
    } finally {
      // This block executes whether an error occurred or not
      // 无论是否发生错误，此块都会执行
      print("Camera initialization process finished.");
      if (mounted) {
        // Ensure loading indicator is turned off
        // 确保加载指示器已关闭
        setState(() {
          _isCameraInitializing = false;
        });
      }
    }
  }


  // Function to start the countdown timer / 启动倒计时的函数
  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer before starting a new one / 在启动新定时器之前取消任何现有定时器
    _remainingSeconds = 8; // Reset countdown / 重置倒计时
    if(mounted) setState(() {}); // Update UI immediately / 立即更新 UI

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { // Check if the widget is still in the tree / 检查小部件是否仍在树中
        timer.cancel(); // Stop timer if widget is disposed / 如果小部件已释放，则停止计时器
        return;
      }
      if (_remainingSeconds > 0) {
        // Decrease remaining time and update UI
        // 减少剩余时间并更新 UI
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel(); // Stop the timer when countdown reaches zero / 当倒计时达到零时停止计时器
        print("Countdown finished!");
        _takePictureAndUpload(); // Call the function to take picture and upload / 调用拍照和上传的函数
      }
    });
  }

  // --- Function to handle retake button press / 处理重拍按钮按下的函数 ---
  void _handleRetake() {
    print("Retake button pressed. Re-initializing camera and timer...");
    _startTimer(); // Restart timer / 重新启动计时器
    _initializeCamera(); // Re-initialize camera / 重新初始化相机
  }

  // --- Combined function for taking picture and initiating upload ---
  // --- 用于拍照和启动上传的组合函数 ---
  Future<void> _takePictureAndUpload() async {
    print("Attempting to take picture...");
    // Ensure controller exists, is initialized, and not already taking a picture
    // 确保控制器存在、已初始化且未在拍照中
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Error: Camera controller is not initialized.');
      // Optionally show a message to the user via Snackbar or Dialog
      // （可选）通过 Snackbar 或 Dialog 向用户显示消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('相机尚未准备好')), // Camera is not ready
        );
      }
      return;
    }
    if (_cameraController!.value.isTakingPicture) {
      // Avoid taking multiple pictures simultaneously
      // 避免同时拍摄多张照片
      print('Error: Already taking picture.');
      return;
    }

    // Ensure the widget is still mounted before proceeding with async operations
    // 在继续异步操作之前，确保小部件仍处于挂载状态
    if (!mounted) {
      print("Widget not mounted. Aborting picture taking.");
      return;
    }

    try {
      print("Calling takePicture()...");
      // Take the picture and get the XFile object
      // 拍照并获取 XFile 对象
      final XFile imageXFile = await _cameraController!.takePicture();
      print('Picture saved temporarily to ${imageXFile.path}'); // Path is usually temporary / 路径通常是临时的

      // --- Create Metadata Entity (UploadEntity without image path) ---
      // --- 创建元数据实体（不含图片路径的 UploadEntity）---
      // Populate with relevant metadata, excluding the image file itself
      // 填入相关元数据，不包括图像文件本身
      UploadEntity metadata = UploadEntity() // Create entity for metadata ONLY / 仅为元数据创建实体
        ..deviceId = "3facfcaed38a4526a33818478889a279" // Example Device ID / 示例设备 ID
        ..source = "22"     // Example Source ID / 示例来源 ID
      // ..userId = "YOUR_USER_ID", // Example User ID (if needed) / 示例用户 ID（如果需要）
        ..type = "1";        // Example Type ID / 示例类型 ID
      // NOTE: metadata.img is intentionally left null or unset here.
      // 注意：这里的 metadata.img 被有意地保留为 null 或未设置。

      // Use toJson() if available in UploadEntity for logging
      // 如果 UploadEntity 中有 toJson()，则用其记录日志
      print("Created Metadata Entity: ${metadata.toJson()}");

      // --- Convert XFile to File ---
      // --- 将 XFile 转换为 File ---
      // This step is necessary because the UploadRepository expects a dart:io File object.
      // 此步骤是必需的，因为 UploadRepository 期望一个 dart:io File 对象。
      final File imageFile = File(imageXFile.path);

      // *** ADDED: Print image file information ***
      // *** 新增：打印图片文件信息 ***
      try {
        if (await imageFile.exists()) {
          final fileSize = await imageFile.length(); // Get file size asynchronously / 异步获取文件大小
          final lastModified = await imageFile.lastModified(); // Get last modified time / 获取最后修改时间
          print("--- Preparing to upload image ---");
          print("  路径 (Path): ${imageFile.path}");
          print("  大小 (Size): $fileSize bytes (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)"); // Convert bytes to MB / 将字节转换为 MB
          print("  最后修改时间 (Last Modified): $lastModified");
          print("---------------------------------");
        } else {
          print("Error: Image file does not exist at path: ${imageFile.path}");
        }
      } catch (e) {
        print("Error getting image file info: $e");
      }
      // *** End of added print statements ***


      // --- Call the uploadPhoto method from the controller ---
      // --- 调用控制器中的 uploadPhoto 方法 ---
      // Pass the File object and the metadata entity separately
      // 分别传递 File 对象和元数据实体
      print("Calling _uploadController.uploadPhoto with File and Metadata...");
      // *** IMPORTANT: Ensure UploadController.uploadPhoto accepts ***
      // *** (File imageFile, UploadEntity metadata) arguments     ***
      // *** 重要提示：确保 UploadController.uploadPhoto 接受       ***
      // *** (File imageFile, UploadEntity metadata) 参数          ***
      await _uploadController.uploadPhoto(imageFile, metadata);
      print("_uploadController.uploadPhoto call finished.");

      // --- Navigate after upload attempt ---
      // --- 上传尝试后导航 ---
      // Check if still mounted before navigation
      // 导航前检查是否仍处于挂载状态
      if (mounted) {
        // Check the state in your UploadController to confirm success before navigating.
        // For example, check if uploadResult is not null.
        // 在导航前检查 UploadController 中的状态以确认成功。
        // 例如，检查 uploadResult 是否不为 null。
        print("Checking upload status (example): ${_uploadController.uploadResult.value}");
        if (_uploadController.uploadResult.value != null) { // Example check for success / 成功示例检查
          print("Navigating to AutoGenPicPage...");
          // Use pushReplacement to prevent user from going back to the camera page
          // 使用 pushReplacement 防止用户返回相机页面
          String? insUrl =_uploadController.uploadResult.value?.insUrl;
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const AutoGenPicPage(insUrl: state.pathParameters['insUrl']!,)),
          // );
          if (insUrl != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AutoGenPicPage(insUrl: insUrl!), // 注意去掉了 const
              ),
            );
          } else {
            // 处理 insUrl 为空的情况
            print('insUrl is null');
          }

          print("Navigator.pushReplacement called.");
        } else {
          print("Upload might have failed (based on controller state). Not navigating.");
          // Show an error message to the user (e.g., using a Snackbar)
          // 向用户显示错误消息（例如，使用 Snackbar）
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('图片上传失败，请重试')), // Image upload failed, please retry
          );
        }
      } else {
        print("Not mounted after upload call. Navigation skipped.");
      }

    } on CameraException catch (e) {
      // Handle errors during picture taking
      // 处理拍照过程中的错误
      print('CameraException taking picture: ${e.code} - ${e.description}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('拍照失败: ${e.description}')), // Error taking picture
        );
      }
    } catch (e, stackTrace) {
      // Handle other errors during the process
      // 处理过程中的其他错误
      print('Error taking picture or during upload preparation: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发生错误: $e')), // An error occurred
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // --- Camera Preview Widget ---
    // --- 相机预览小部件 ---
    Widget cameraPreviewWidget;
    if (_initializeControllerFuture == null && _isCameraInitializing) {
      // Initializing state or retake state before future is set
      // 初始化状态或在设置 future 之前的重拍状态
      cameraPreviewWidget = const Center(child: CircularProgressIndicator());
    } else {
      // Use FutureBuilder once the initialization future is available
      // 初始化 future 可用后使用 FutureBuilder
      cameraPreviewWidget = FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // Show loading indicator while waiting or initializing
          // 等待或初始化时显示加载指示器
          if (snapshot.connectionState == ConnectionState.waiting || _isCameraInitializing) {
            return const Center(child: CircularProgressIndicator());
          }
          // Show error message if initialization failed
          // 如果初始化失败，则显示错误消息
          else if (snapshot.hasError) {
            print("FutureBuilder: Error initializing camera - ${snapshot.error}");
            String errorMessage = '无法初始化相机'; // Cannot initialize camera
            if (snapshot.error is CameraException) {
              errorMessage += '\n错误: ${(snapshot.error as CameraException).description}'; // Error
            } else {
              errorMessage += '\n错误: ${snapshot.error}'; // Error
            }
            return Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
            ));
          }
          // Show camera preview if initialized successfully
          // 如果初始化成功，则显示相机预览
          else if (_cameraController != null && _cameraController!.value.isInitialized) {
            // *** MODIFIED: Use FittedBox to make preview fill the container ***
            // *** 修改：使用 FittedBox 使预览填充容器 ***
            return FittedBox(
              fit: BoxFit.cover, // Scale and crop to fill / 缩放和裁剪以填充
              child: SizedBox(
                // Set the size based on the camera's aspect ratio to avoid distortion before BoxFit.cover crops it.
                // 根据相机的宽高比设置尺寸，以避免在 BoxFit.cover 裁剪之前发生变形。
                // Note: Camera aspect ratio might be landscape (e.g., 16:9), FittedBox handles covering the portrait container.
                // 注意：相机宽高比可能是横向的（例如 16:9），FittedBox 会处理覆盖纵向容器。
                width: _cameraController!.value.previewSize!.height, // Use height for width in portrait
                height: _cameraController!.value.previewSize!.width, // Use width for height in portrait
                child: CameraPreview(_cameraController!), // Display the preview / 显示预览
              ),
            );
            /* // --- OLD CODE using AspectRatio ---
            // --- 使用 AspectRatio 的旧代码 ---
            return Center( // Center the preview within its container / 将预览居中放置在其容器内
              child: AspectRatio(
                // Use the camera's aspect ratio. Note that the physical sensor might be landscape,
                // but the controller handles rotation for portrait preview.
                // 使用相机的宽高比。请注意，物理传感器可能是横向的，但控制器会处理旋转以进行纵向预览。
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!), // Display the preview / 显示预览
              ),
            );
            */
          }
          // Fallback for unknown state
          // 未知状态的回退
          else {
            print("FutureBuilder: Camera not ready after future completion.");
            return const Center(child: Text('相机准备中...', style: TextStyle(color: Colors.white))); // Camera is preparing...
          }
        },
      );
    }


    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Left Column: Vertical Text / 左列：垂直文本 ---
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

              // --- Center Column: Camera Preview and Action Buttons / 中间列：相机预览和操作按钮 ---
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Stack for layering the camera preview and overlay
                    // 用于分层相机预览和覆盖层的 Stack
                    SizedBox(
                      // These dimensions already favor portrait (height > width)
                      // 这些尺寸已经倾向于纵向（高 > 宽）
                      width: 300, // Adjust width as needed / 根据需要调整宽度
                      height: 450, // Adjust height as needed / 根据需要调整高度
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // --- Camera Preview Area / 相机预览区域 ---
                          Positioned.fill(
                            child: Container(
                              clipBehavior: Clip.hardEdge, // Clip the preview to rounded corners / 将预览裁剪为圆角
                              decoration: BoxDecoration(
                                color: Colors.black, // Background for loading/error states / 加载/错误状态的背景
                                borderRadius: BorderRadius.circular(20), // Rounded corners / 圆角
                                border: Border.all(color: Colors.grey.shade700, width: 2), // Optional border / 可选边框
                              ),
                              // Embed the cameraPreviewWidget defined above
                              // 嵌入上面定义的 cameraPreviewWidget
                              child: cameraPreviewWidget, // This now contains the FittedBox / 现在包含 FittedBox
                            ),
                          ),

                          // --- Bottom Timer Overlay / 底部定时器覆盖层 ---
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.black54, // Semi-transparent background / 半透明背景
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  // Show '拍摄中...' (Taking picture...) when timer hits 0 or during picture taking
                                  // 当计时器达到 0 或在拍照过程中显示 '拍摄中...'
                                  _remainingSeconds > 0 ? _remainingSeconds.toString() : "拍摄中...",
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
                    const SizedBox(height: 20), // Spacing / 间距

                    // --- Action Buttons / 操作按钮 ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 'Next' button (Now triggers combined take/upload)
                        // '下一步' 按钮（现在触发组合的拍照/上传）
                        ElevatedButton.icon(
                          // Disable button while timer is running > 0 or if camera is not ready
                          // 当计时器 > 0 或相机未就绪时禁用按钮
                          onPressed: (_remainingSeconds > 0 || _cameraController == null || !_cameraController!.value.isInitialized)
                              ? null // Disabled state / 禁用状态
                              : _takePictureAndUpload, // Enabled state action / 启用状态操作
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('下一步'), // Next Step
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan, // Button color / 按钮颜色
                            foregroundColor: Colors.white, // Text/Icon color / 文本/图标颜色
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners / 圆角
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding / 内边距
                          ).copyWith(
                            // Style for disabled state / 禁用状态的样式
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.grey; // Disabled color / 禁用颜色
                                }
                                return Colors.cyan; // Enabled color / 启用颜色
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 20), // Spacing / 间距
                        // 'Retake' button / '重拍' 按钮
                        ElevatedButton.icon(
                          onPressed: _handleRetake, // Call the handler function / 调用处理函数
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

              // --- Right Column: Mirror Controls / 右列：镜子控制 ---
              // (Assuming this is placeholder UI for now)
              // (假设这暂时是占位符 UI)
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
