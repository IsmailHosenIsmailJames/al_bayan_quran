import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showTwoestedMessage(String message) {
  toastification.show(
    title: Text(message),
  );
}
