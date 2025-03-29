import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class MediaStoreHelper {
  /// **Guarda un video en la galería usando MediaStore (Android 10+)**
  static Future<bool> saveVideo(String filePath) async {
    try {
      File videoFile = File(filePath);
      if (!videoFile.existsSync()) return false;

      final Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) return false;

      String newFilePath = '${externalDir.path}/video.mp4';

      await videoFile.copy(newFilePath); // ✅ Corrección: Eliminar variable innecesaria

      debugPrint('✅ Video guardado en: $newFilePath');
      return true;
    } catch (e) {
      debugPrint('❌ Error en MediaStoreHelper: $e');
      return false;
    }
  }
}
