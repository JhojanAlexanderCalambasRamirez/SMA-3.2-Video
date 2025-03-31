import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/upload_screen.dart';
import 'package:flutter_application_1/screens/decision_video_screen.dart';
import 'package:flutter_application_1/screens/summary_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/upload': (context) => const UploadScreen(),
    '/decision': (context) => const DecisionVideoScreen(),
    '/summary': (context) => SummaryScreen(),
  };
}
