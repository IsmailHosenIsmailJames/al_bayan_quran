import 'package:flutter/material.dart';

class SurahViewReading extends StatefulWidget {
  final int surahNumber;
  final int? start;
  final int? end;
  final String? surahName;
  final int? scrollToAyah;
  const SurahViewReading({
    super.key,
    required this.surahNumber,
    this.start,
    this.end,
    required this.surahName,
    this.scrollToAyah,
  });

  @override
  State<SurahViewReading> createState() => _SurahViewReadingState();
}

class _SurahViewReadingState extends State<SurahViewReading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
