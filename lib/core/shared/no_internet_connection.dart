import 'package:dmj_task/core/utils/extension.dart';
import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(170, 74, 74, 74),
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_2_bar_outlined,
                size: 100, color: Colors.white),
            20.ph,
            const Text(
              'App no internet connection please check your network',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
