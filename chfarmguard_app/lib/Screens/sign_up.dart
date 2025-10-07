import 'package:flutter/material.dart';
import '../Screens/sign_in.dart'; // import your SignInScreen

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 60),
              // --- Screen Title ---
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 48),

              // --- Full Name Field ---
              _buildTextField(
                hintText: 'Tanya Myroniuk',
                labelText: 'Full Name',
                icon: Icons.person_outline,
                initialValue: 'Tanya Myroniuk',
              ),
              const SizedBox(height: 24),

              // --- Phone Number Field ---
              _buildTextField(
                hintText: '+8801712663389',
                labelText: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                initialValue: '+8801712663389',
              ),
              const SizedBox(height: 24),

              // --- Email Address Field ---
              _buildTextField(
                hintText: 'tanyamyroniuk@gmail.com',
                labelText: 'Email Address',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                initialValue: 'tanyamyroniuk@gmail.com',
              ),
              const SizedBox(height: 24),

              // --- Password Field ---
              _buildPasswordTextField(
                hintText: '••••••••••',
                labelText: 'Password',
                initialValue: 'password123',
              ),
              const SizedBox(height: 40),

              // --- Sign Up Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle sign-up logic or navigate to Home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0066FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),

              // --- Already have an account ---
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build TextFields
  Widget _buildTextField({
    required String hintText,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: Icon(icon, color: Colors.grey[700]),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for Password Field
  Widget _buildPasswordTextField({
    required String hintText,
    required String labelText,
    String? initialValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        TextFormField(
          initialValue: initialValue,
          obscureText: true,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[700]),
            suffixIcon:
                Icon(Icons.remove_red_eye_outlined, color: Colors.grey[700]),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}
