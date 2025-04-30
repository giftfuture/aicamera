import 'dart:math';

import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart';

// --- CoreController (Ensure this exists and is initialized ONCE, e.g., in bindings) ---
class PicCoreController extends GetxController {
  final random = Random();
  String deviceId = "3facfcaed38a4526a33818478889a279"; // Replace with actual logic
  final RxnInt remainingTrials = RxnInt(null); // Example state
  final RxnString userLevel = RxnString(null); // Example state

  @override
  void onInit() {
    super.onInit();
    // Fetch initial data
    fetchUserData();
  }

  void fetchUserData() {
    // Simulate fetching user data
    Future.delayed(Duration(milliseconds: 500), () {
      remainingTrials.value = 5; // Example value
      userLevel.value = "VIP"; // Example value
    });
  }
}
// --- End CoreController ---