import 'dart:async';

import 'package:dmj_task/config/local_data/flutter_secure_storage.dart';
import 'package:dmj_task/core/di/di.dart';
import 'package:dmj_task/core/resources/image_assets_manager.dart';
import 'package:dmj_task/core/shared/toast_state.dart';
import 'package:dmj_task/core/utils/extension.dart';
import 'package:dmj_task/core/widget/animation_widget.dart';
import 'package:dmj_task/core/widget/button_widget.dart';
import 'package:dmj_task/core/widget/text_field_widget.dart';
import 'package:dmj_task/features/auth/logic/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late GlobalKey<FormState> _formKey;

  final ValueNotifier<bool> _passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> _confirmPasswordNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
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
        title: const Text("Sign Up"),
        titleTextStyle: const TextStyle(color: Colors.white),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
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
                  'Join us now and enjoy a unique experience.',
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
              TextFieldWidget(
                titleField: "Username",
                hintField: "Username",
                controller: _usernameController,
                obscureText: false,
                validator: (value) {
                  if (value.isEmpty) return "Please enter your username";
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
              10.ph,
              ValueListenableBuilder<bool>(
                valueListenable: _passwordNotifier,
                builder: (context, value, child) {
                  return TextFieldWidget(
                    titleField: "Confirm Password",
                    hintField: "Confirm Password",
                    controller: _confirmPasswordController,
                    obscureText: value,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter your confirm password";
                      }
                    },
                    onChanged: (value) {},
                    suffixIcon: IconButton(
                      icon: Icon(
                        value ? Icons.visibility_off : Icons.visibility,
                        color: Colors.orange,
                      ),
                      onPressed: () => _confirmPasswordNotifier.value =
                          !_confirmPasswordNotifier.value,
                    ),
                  );
                },
              ),
              30.ph,
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is SignUpSuccess) {
                    toastSuccess(message: state.message);
                    Navigator.pop(context);
                  } else if (state is SignUpError) {
                    toastError(message: state.error);
                  }
                },
                builder: (context, state) {
                  if (state is SignUpLoading) {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    ).center;
                  } else {
                    return ButtonWidget(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            toastWarning(message: "Password Not Match");
                            return;
                          }
                          context.read<AuthCubit>().signUp(
                                email: _emailController.text,
                                password: _passwordController.text,
                                username: _usernameController.text,
                              );
                        } else {
                          toastWarning(message: "Please Check Your Field");
                        }
                      },
                      txt: "Sign Up",
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
              "I have an account ? ",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            10.pw,
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                " Login",
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ).center,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
