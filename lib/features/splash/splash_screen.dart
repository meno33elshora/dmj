import 'dart:async';
import 'package:dmj_task/config/local_data/flutter_secure_storage.dart';
import 'package:dmj_task/config/routes/routes.dart';
import 'package:dmj_task/core/resources/image_assets_manager.dart';
import 'package:dmj_task/core/utils/extension.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 2), () async {
      var keyLogin = await FlutterSecureHelper.instance.getObject("login");
      if (keyLogin != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.home, (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.login, (route) => false);
      }
    });
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImageAssets.logo,
            scale: 0.9,
          ),
        ],
      ).center,
      bottomNavigationBar: Container(
        color: Colors.black,
        height: 50,
        child: const Text(
          'Developed By : DMJ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ).center,
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
