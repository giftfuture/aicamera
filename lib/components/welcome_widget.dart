import 'package:flutter/material.dart';

class WelcomeTopWidget extends StatelessWidget {
  const WelcomeTopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60,),
        Row(
          children: [
            const Spacer(),
            Image.asset("assets/image/login_smile.png",width: 60,),
            const SizedBox(width: 40,),
          ],
        ),
        const SizedBox(height: 30,),
        Image.asset("assets/image/login_coffee.png",width: 195,),
        const SizedBox(height: 30,),
        const Text("Let's enjoy a drink life"),
        const SizedBox(height: 40,),
      ],
    );
  }
}
