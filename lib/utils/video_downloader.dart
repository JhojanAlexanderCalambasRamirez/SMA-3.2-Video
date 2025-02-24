import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class VideoDownloader {
  Future<String?> downloadVideo(String videoUrl) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/video.mp4';

      await Dio().download(videoUrl, filePath);
      return filePath;
    } catch (e) {
      print("Error descargando el video: $e");
      return null;
    }
  }
}
