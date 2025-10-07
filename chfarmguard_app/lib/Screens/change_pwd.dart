import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // State variables for password visibility (common for security screens)
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // The hint text for the validation error
  final String validationHint = 'Both Passwords Must Match';

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
          'Change Password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 48),

            // --- Current Password Field ---
            _buildPasswordField(
              labelText: 'Current Password',
              isObscure: !_isCurrentPasswordVisible,
              toggleVisibility: () {
                setState(() {
                  _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 24),

            // --- New Password Field ---
            _buildPasswordField(
              labelText: 'New Password',
              isObscure: !_isNewPasswordVisible,
              toggleVisibility: () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 24),

            // --- Confirm New Password Field ---
            _buildPasswordField(
              labelText: 'Cofirm New Password',
              isObscure: !_isConfirmPasswordVisible,
              toggleVisibility: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              // The hint for 'Both Passwords Must Match' is placed after the input
              // as suggested by the image layout.
              trailingWidget: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  validationHint,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600], // Use a subtle color for the hint
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),

            // --- Change Password Button ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Implement the password change logic here
                  print('Change Password button pressed!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700], // Primary blue color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Change Password',
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

  // Helper widget to build the custom Password TextFields
  Widget _buildPasswordField({
    required String labelText,
    required bool isObscure,
    required VoidCallback toggleVisibility,
    Widget? trailingWidget,
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
          obscureText: isObscure, // Hides/shows the input
          keyboardType: TextInputType.visiblePassword,
          style: const TextStyle(
            color: Colors.black, // Input text color
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0, // Spacing for the dots
          ),
          decoration: InputDecoration(
            isDense: true,
            // Prefix Icon (Lock)
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey[700],
            ),
            // Suffix Icon (Eye for visibility)
            suffixIcon: IconButton(
              icon: Icon(
                isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey[700],
              ),
              onPressed: toggleVisibility,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
            // Underline border styling
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
        // The optional trailing widget (e.g., "Both Passwords Must Match")
        if (trailingWidget != null) trailingWidget,
      ],
    );
  }
}