import 'package:flutter/material.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({super.key});

  // The text content of the terms and conditions
  final String termsContent = """
1.1 Thank you for visiting our Application Doctor 24×7 and enrolling as a member.

1.2 Your privacy is important to us. To better protect your privacy, we are providing this notice explaining our policy with regards to the information you share with us. This privacy policy relates to the information we collect, online from Application, received through the email, by fax or telephone, or in person or in any other way and retain and use for the purpose of providing you services. If you do not agree to the terms in this Policy, we kindly ask you not to use these portals and/or sign the contract document.

1.3 In order to use the services of this Application, You are required to register yourself by verifying the authorised device. This Privacy Policy applies to your information that we collect and receive on and through Doctor 24×7; it does not apply to practices of businesses that we do not own or control or people we do not employ.

1.4 By using this Application, you agree to the terms of this Privacy Policy.

1.5 Any unauthorized use of the Application, including but not limited to unauthorized entry into the Application's systems, misuse of passwords, or misuse of any information posted on a site, is strictly prohibited. You agree that you will not engage in any activities related to this Application that are contrary to applicable laws or regulations.

1.6 We reserve the right to change, modify, add, or remove portions of these terms at any time. Please check these terms and conditions periodically for changes. Your continued use of the Application following the posting of changes will mean that you accept and agree to the changes.
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Text(
            termsContent.trim(),
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}