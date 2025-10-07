import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  // Example data (replace with actual user data logic)
  final String fullName = 'Tanya Myroniuk';
  final String userId = '00012';
  final String emailAddress = 'tanya myroniuk@gmail.com';
  final String phoneNumber = '+8801712663389';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // Implement back navigation functionality here
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 32),

            // --- Profile Name and ID Section ---
            Text(
              fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'id: $userId',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 48),

            // --- Full Name Field ---
            _buildTextField(
              labelText: 'Full Name',
              icon: Icons.person_outline,
              initialValue: fullName,
            ),
            const SizedBox(height: 24),

            // --- Email Address Field ---
            _buildTextField(
              labelText: 'Email Address',
              icon: Icons.mail_outline,
              initialValue: emailAddress,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),

            // --- Phone Number Field ---
            _buildTextField(
              labelText: 'Phone Number',
              icon: Icons.phone_outlined,
              initialValue: phoneNumber,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 48),

            // --- Edit Button ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Implement the profile update logic here
                  print('Edit Profile button pressed!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700], // Primary blue color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the custom TextFields (reused from Sign Up screen logic)
  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String initialValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The Label Text (Faint Grey)
        Text(
          labelText,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Colors.black, // Input text color
            fontSize: 16,
            fontWeight: FontWeight.w600, // Slightly bolder for the input
          ),
          decoration: InputDecoration(
            isDense: true, // Makes the field more compact
            // Prefix Icon on the left
            prefixIcon: Icon(
              icon,
              color: Colors.grey[700],
            ),
            // Padding and border styling for the underline look
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue, // Active focus color
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}