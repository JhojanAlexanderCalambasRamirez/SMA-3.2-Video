import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class VideoDownloader {
  static Future<String?> copyVideoToLocal() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/video.mp4';

      // Verificar si ya existe el video
      if (File(filePath).existsSync()) {
        debugPrint('✅ Video ya está guardado localmente.');
        return filePath;
      }

      // Copiar el video desde assets a almacenamiento local
      ByteData data = await rootBundle.load('assets/videos/VideoEjemplo.mp4');
      List<int> bytes = data.buffer.asUint8List();
      await File(filePath).writeAsBytes(bytes);

      debugPrint('✅ Video guardado localmente en $filePath');
      return filePath;
    } catch (e) {
      debugPrint('❌ Error al copiar el video: $e');
      return null;
    }
  }
}
