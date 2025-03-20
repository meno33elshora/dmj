import 'dart:async';

import 'package:dmj_task/config/local_data/flutter_secure_storage.dart';
import 'package:dmj_task/config/routes/routes.dart';
import 'package:dmj_task/core/di/di.dart';
import 'package:dmj_task/core/resources/image_assets_manager.dart';
import 'package:dmj_task/core/shared/toast_state.dart';
import 'package:dmj_task/core/utils/extension.dart';
import 'package:dmj_task/core/widget/animation_widget.dart';
import 'package:dmj_task/core/widget/button_widget.dart';
import 'package:dmj_task/core/widget/text_field_widget.dart';
import 'package:dmj_task/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void didChangeDependencies() {
    const splashImage = AssetImage(ImageAssets.logo);
    unawaited(precacheImage(splashImage, context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AnimateWidgetItem(
                indexPositionItem: 1,
                verticalOffset: -100,
                item: Image.asset(
                  ImageAssets.logo,
                  width: double.infinity,
                  scale: 0.9,
                ),
              ),
              AnimateWidgetItem(
                indexPositionItem: 1,
                item: const Text(
                  'Welcome back again, we are happy about that.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ).center,
              ),
              30.ph,
              TextFieldWidget(
                titleField: "Email",
                hintField: "Email",
                controller: _emailController,
                obscureText: false,
                validator: (value) {
                  if (value.isEmpty) return "Please enter your email";
                },
                onChanged: (value) {},
              ),
              10.ph,
              ValueListenableBuilder<bool>(
                valueListenable: _passwordNotifier,
                builder: (context, value, child) {
                  return TextFieldWidget(
                    titleField: "Password",
                    hintField: "Password",
                    controller: _passwordController,
                    obscureText: value,
                    validator: (value) {
                      if (value.isEmpty) return "Please enter your password";
                    },
                    onChanged: (value) {},
                    suffixIcon: IconButton(
                      icon: Icon(
                        value ? Icons.visibility_off : Icons.visibility,
                        color: Colors.orange,
                      ),
                      onPressed: () =>
                          _passwordNotifier.value = !_passwordNotifier.value,
                    ),
                  );
                },
              ),
              30.ph,
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) async {
                  if (state is LoginSuccess) {
                    toastSuccess(message: state.message);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(Routes.home, (route) => false);
                    await FlutterSecureHelper.instance
                        .setObject("login", "done");
                  } else if (state is LoginError) {
                    toastError(message: state.error);
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    ).center;
                  } else {
                    return ButtonWidget(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                        } else {
                          toastWarning(message: "Please Check Your Field");
                        }
                      },
                      txt: "Login",
                      backgroundColor: Colors.orange,
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don\'t have an account? ",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            10.pw,
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.signup);
              },
              child: const Text(
                " Sign up",
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ).center,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
