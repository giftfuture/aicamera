import 'dart:math';

import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart';

// --- CoreController (Ensure this exists and is initialized ONCE, e.g., in bindings) ---
class PicCoreController extends GetxController {
  final random = Random();
  String deviceId = "3facfcaed38a4526a33818478889a279"; // Replace with actual logic

  @override
  void onInit() {
    super.onInit();
    _initializeDeviceId();
  }

  void _initializeDeviceId() {
    // Implement logic to get the actual device ID
    print("CoreController initialized with deviceId: $deviceId");
  }
}
// --- End CoreController ---