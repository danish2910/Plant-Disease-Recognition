import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fypapp/ui/root_page.dart';
import 'package:fypapp/ui/screens/scan_page.dart';
import 'package:fypapp/ui/screens/home_page.dart';
import 'package:fypapp/models/inference_history_provider.dart';
import 'package:provider/provider.dart';
import 'ui/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import FirebaseAuth

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: MaterialApp(
          title: 'Onboarding',
          home: _getRootPage(), // Use the method to decide the home page
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  // This method checks if the user is logged in and returns the appropriate screen
  Widget _getRootPage() {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If the user is logged in, navigate to the Home Page
      return const RootPage();
    } else {
      // If the user is not logged in, navigate to the Onboarding screen
      return const OnboardingScreen();
    }
  }
}
