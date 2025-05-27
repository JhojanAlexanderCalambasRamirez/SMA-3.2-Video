import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/upload_screen.dart';
import '../screens/decision_video_screen.dart';
import '../screens/summary_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/upload': (context) => const UploadScreen(),
    '/decision': (context) => const DecisionVideoScreen(),
    '/summary': (context) => SummaryScreen(),
  };
}
