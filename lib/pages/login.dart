import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/welcome_widget.dart';
import '../controller/login.dart';

/// 登录界面
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(context) {
    LoginController controller = Get.put(LoginController());
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const WelcomeTopWidget(),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.controllerUserName.value,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                            // icon: Icon(Icons.people),
                            hintText: "用户名/邮箱",
                            prefixIcon: Icon(Icons.account_circle_outlined),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            suffixIcon: Icon(Icons.cached_outlined),
                            suffixIconColor: Colors.transparent),
                        validator: (value) {
                          return value!.isEmpty ? '账号不能为空' : null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(() => TextFormField(
                            obscureText: !controller.isShowPassword.value,
                            controller: controller.controllerPassword.value,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                hintText: "密码",
                                prefixIcon: const Icon(Icons.lock_outlined),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.showPassword();
                                    },
                                    icon: Icon(
                                      controller.isShowPassword.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '密码不能为空';
                              }
                              if (value.length <= 6) {
                                return '密码不能低于6位';
                              }
                              return null;
                            },
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          controller.login();
                        },
                        icon: const Icon(Icons.login),
                        label: const Text("    登         录    "),
                      ),
                      // CaptchaWidget(
                      //   imageUrl:
                      //   'shangyuewan-fd3669eb.png',
                      //   onSuccess: () {
                      //     print('CAPTCHA验证成功');
                      //   },
                      //   onFail: () {
                      //     print('CAPTCHA验证失败');
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
