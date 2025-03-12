import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'; // ✅ Agregar esta línea

class VideoDownloader {
  static Future<String?> downloadVideo(String videoUrl) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/video.mp4';

      await Dio().download(videoUrl, filePath);
      return filePath;
    } catch (e) {
      debugPrint('Error descargando el video: $e'); // ✅ Ahora funcionará
      return null;
    }
  }
}
