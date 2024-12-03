import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showTwoestedMessage(String message) {
  toastification.show(
    title: Text(message),
    autoCloseDuration: const Duration(seconds: 2),
    alignment: Alignment(1, 0.8),
  );
}
