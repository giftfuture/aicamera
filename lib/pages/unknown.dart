import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          const Spacer(),
          const Text("出错啦！未找到页面"),
          const SizedBox(height: 30,),
          ElevatedButton(
            onPressed: () { Get.back(); },
            child: const Text("    返         回    "),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
