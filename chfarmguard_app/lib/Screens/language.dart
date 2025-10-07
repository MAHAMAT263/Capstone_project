import 'package:flutter/material.dart';

// Model to represent a language option
class LanguageOption {
  final String code;
  final String name;
  final String flagAsset; // Placeholder for asset path or network URL

  LanguageOption({
    required this.code,
    required this.name,
    required this.flagAsset,
  });
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  // Mock data for the languages
  final List<LanguageOption> allLanguages = [
    LanguageOption(code: 'en', name: 'English', flagAsset: 'assets/us_flag.png'),
    LanguageOption(code: 'ar', name: 'Arabic', flagAsset: 'assets/saudi_flag.png'),
    LanguageOption(code: 'fr', name: 'French', flagAsset: 'assets/french_flag.png'),
    // Add more languages here
  ];

  // State to track the currently selected language
  String _selectedLanguageCode = 'en'; // English is selected by default/in the image

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
          'Language',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100], // Light grey background
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Language',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none, // Remove default border
                  contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                ),
                // Add onChanged logic here to filter the list
              ),
            ),
          ),
          
          // --- Language List ---
          Expanded(
            child: ListView.builder(
              itemCount: allLanguages.length,
              itemBuilder: (context, index) {
                final language = allLanguages[index];
                return _buildLanguageItem(language);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build a single language selection item
  Widget _buildLanguageItem(LanguageOption language) {
    final isSelected = language.code == _selectedLanguageCode;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguageCode = language.code;
        });
        // Logic to actually change the app's language would go here
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            // --- Flag Image Placeholder ---
            // NOTE: In a real application, you must use Image.asset() 
            // with your flag images stored in the 'assets' folder
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                // Placeholder for flag image
                color: Colors.grey[300],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: ClipOval(
                // Replace with actual flag image widget (e.g., Image.asset)
                child: Text(
                  // Use a simple text placeholder for demonstration
                  language.code.toUpperCase(), 
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, height: 3.0),
                ),
              ),
            ),

            // --- Language Name ---
            Expanded(
              child: Text(
                language.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            // --- Checkmark Icon ---
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.blue, // Primary checkmark color
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

// NOTE on Flags: 
// To display the actual flags, you need to add your flag images (e.g., 'us_flag.png', 'saudi_flag.png') 
// to your Flutter project's 'assets' folder and update the pubspec.yaml file.
// Then, replace the placeholder Container/Text with: 
// Image.asset(language.flagAsset, fit: BoxFit.cover)