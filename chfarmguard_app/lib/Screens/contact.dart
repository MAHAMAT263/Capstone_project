import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // CONTACT DETAILS
  final String email = "support@chfarmguard.com";
  final String phone = "+250 790 005951";

  // FUNCTIONS TO OPEN EMAIL AND PHONE
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    await launchUrl(emailUri);
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    await launchUrl(phoneUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Contact Us",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // MAIN CONTENT
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Need help or want to reach out?\nWe are here for you.",
              style: TextStyle(
                fontSize: 18,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 40),

            // EMAIL CARD
            GestureDetector(
              onTap: () => _launchEmail(email),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.blue, size: 28),
                  title: Text(
                    email,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: const Text("Send us an email"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PHONE CARD
            GestureDetector(
              onTap: () => _launchPhone(phone),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green, size: 28),
                  title: Text(
                    phone,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: const Text("Call or WhatsApp us"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
