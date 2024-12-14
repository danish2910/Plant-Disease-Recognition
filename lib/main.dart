import 'package:flutter/material.dart';
import 'package:fypapp/ui/screens/scan_page.dart';
import 'package:fypapp/ui/screens/home_page.dart';
import 'package:fypapp/models/inference_history_provider.dart';
import 'package:provider/provider.dart';
import 'ui/onboarding_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => InferenceHistoryProvider(),
      child: const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Onboarding',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

