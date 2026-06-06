import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/core/theme/app_theme.dart';
import 'views/screens/loading_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padel Book',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoadingScreen(),
    );
  }
}