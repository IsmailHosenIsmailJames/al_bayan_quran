import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getAudioCachedPath(String url) async {
  final cachedPath = await getApplicationCacheDirectory();
  String audioPath = join(cachedPath.path, url.split("data/").last);
  bool isExits = await File(audioPath).exists();
  if (isExits) {
    return audioPath;
  } else {
    return downloadAudioAndGivePath(audioPath, url);
  }
}

Future<String> downloadAudioAndGivePath(String path, String url) async {
  final client = Dio();
  await client.download(url, path);
  return path;
}
