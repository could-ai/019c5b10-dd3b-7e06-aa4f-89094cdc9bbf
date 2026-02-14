import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'dashboard_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Placement Readiness Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Primary color: hsl(245, 58%, 51%) -> #4F46E5
        primaryColor: const Color(0xFF4F46E5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          primary: const Color(0xFF4F46E5),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/dashboard': (context) => const DashboardLayout(),
      },
    );
  }
}
