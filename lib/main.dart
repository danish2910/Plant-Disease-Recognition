import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fypapp/ui/screens/scan_page.dart';
import 'package:fypapp/ui/screens/home_page.dart';
import 'package:fypapp/models/inference_history_provider.dart';
import 'package:provider/provider.dart';
import 'ui/onboarding_screen.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (_) => InferenceHistoryProvider(),
      child: MyApp(),
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

