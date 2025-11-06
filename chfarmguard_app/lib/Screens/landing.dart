import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/onbording.dart'; // Your existing onboarding/info screen
import '../Screens/home.dart'; // Your home screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait 3-5 seconds then navigate based on login status
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // User is logged in -> go to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // User not logged in -> go to onboarding/info screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InfoScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D19), // Dark navy color
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              // App Logo
              Image.asset(
                'assets/img/logo.png', // path to your logo
                width: 260,
                height: 260,
              ),
              const SizedBox(height: 50),
              // Loading text
              const Text(
                "Loading...",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
