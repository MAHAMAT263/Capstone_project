import 'package:flutter/material.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({super.key});

  // The text content of the terms and conditions
  final String termsContent = """
1. Introduction  
1.1 Thank you for using our ChFarmGuard mobile application (“the App”).  
1.2 By accessing or using this App, you agree to the following Terms & Conditions. If you do not agree, please discontinue use immediately.

2. Purpose of the Application  
2.1 The App works together with an IoT-based animal intrusion detection system installed on farms.  
2.2 The system captures images of animals, sends real-time alerts, and provides notification options (SMS, online alerts, or sound deterrents).  
2.3 The App is intended for farm monitoring, crop protection, and community conflict-prevention support.

3. Registration & User Responsibility  
3.1 To use the App, you may be required to create an account or verify your device.  
3.2 You agree to provide accurate information and keep your login credentials secure.  
3.3 You are responsible for all activity conducted through your account.  
3.4 Unauthorized access to the system, including attempting to manipulate alerts, copy data, or bypass security, is strictly prohibited.

4. Data Collection & Privacy  
4.1 The App may collect certain data such as:
• phone number (for alerts),  
• email address (for account management),

4.2 The IoT device used with the App captures images **only when motion is detected**, and these images may be sent to your device for alert purposes.

4.3 Images containing people or non-threatening objects are **immediately deleted** by the system and are not stored.

4.4 Images of animals that pose a real risk to crops (e.g., goats, cows ) may be temporarily stored for system improvement and verification and deleted in one mounth.

4.5 All images are encrypted and accessible only to authorized research or system personnel.

4.6 By using this App, you consent to this data handling approach.

5. User Conduct  
5.1 You agree NOT to use the App or associated hardware to:  
• violate local laws,  
• harm others or escalate disputes,  
• misuse captured images as evidence in conflicts,  
• attempt unauthorized access to servers or data.  

5.2 The App is designed to support conflict prevention, not to assign blame or create tension between farmers and herders.

6. System Limitations  
6.1 Detection accuracy may vary depending on environmental conditions (lighting, weather, camera placement).  
6.2 Network connectivity or GSM coverage may affect notification speed.  
6.3 We do not guarantee uninterrupted service, nor can we be held responsible for crop damage occurring during system downtime.

7. Liability  
7.1 The App and connected devices are provided “as is”.  
7.2 We are not liable for:  
• losses resulting from missed alerts or technical failures,  
• misuse of the App by the user,  
• disputes arising between community members.  

7.3 Users are encouraged to treat alert information as supportive—not definitive data.

8. Changes to Terms  
8.1 We may update these Terms & Conditions at any time to reflect improvements or legal requirements.  
8.2 Continued use of the App after updates means you accept the revised terms.

9. Contact  
If you have questions, concerns, or wish to withdraw from the research project, please contact the project team or the designated support office.
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
