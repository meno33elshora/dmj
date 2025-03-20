import 'package:flutter/material.dart';

extension CenterWidget on Widget {
  Widget get center => Center(
        child: this,
      );
}

extension Sized on num {
  Widget get ph => SizedBox(
        height: toDouble(),
      );
  Widget get pw => SizedBox(
        width: toDouble(),
      );
}
