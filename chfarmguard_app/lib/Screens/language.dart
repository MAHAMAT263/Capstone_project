import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

// Model to represent a language option
class LanguageOption {
  final String code;
  final String name;
  final String flagAsset;

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
  final translator = GoogleTranslator();

  final List<LanguageOption> allLanguages = [
    LanguageOption(code: 'en', name: 'English', flagAsset: 'assets/us_flag.png')
  ];

  String _selectedLanguageCode = 'en'; // default
  List<LanguageOption> _filteredLanguages = [];

  // Example UI texts
  String titleText = "Select Language";
  String searchHint = "Search Language";

  @override
  void initState() {
    super.initState();
    _filteredLanguages = allLanguages;
    _loadSelectedLanguage();
  }

  // Load selected language from SharedPreferences
  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('selected_language');
    if (savedCode != null) {
      setState(() {
        _selectedLanguageCode = savedCode;
      });
      _translateUI(savedCode); // translate texts
    }
  }

  // Save selected language to SharedPreferences
  Future<void> _saveSelectedLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', code);
  }

  // Filter languages based on search query
  void _filterLanguages(String query) {
    final filtered = allLanguages.where((lang) {
      return lang.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredLanguages = filtered;
    });
  }

  // Translate UI texts dynamically
  Future<void> _translateUI(String targetLang) async {
    final titleTrans =
        await translator.translate("Select Language", to: targetLang);
    final searchTrans =
        await translator.translate("Search Language", to: targetLang);

    setState(() {
      titleText = titleTrans.text;
      searchHint = searchTrans.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          titleText,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // Search bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                onChanged: _filterLanguages,
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 10.0),
                ),
              ),
            ),
          ),

          // Language list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLanguages.length,
              itemBuilder: (context, index) {
                final language = _filteredLanguages[index];
                return _buildLanguageItem(language);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(LanguageOption language) {
    final isSelected = language.code == _selectedLanguageCode;

    return InkWell(
      onTap: () async {
        setState(() {
          _selectedLanguageCode = language.code;
        });
        await _saveSelectedLanguage(language.code);
        await _translateUI(language.code); // translate UI immediately
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            // Flag image
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 16.0),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(language.flagAsset, fit: BoxFit.cover),
              ),
            ),

            // Language name
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

            // Checkmark if selected
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
