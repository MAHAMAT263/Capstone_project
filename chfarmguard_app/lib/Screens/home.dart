import 'package:flutter/material.dart';
import 'settings.dart';

// --- Assets Placeholders ---
const String warningImageUrl = 'https://picsum.photos/id/106/500/300';
const String safeImageUrl = 'https://picsum.photos/id/102/500/300';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWarning = true;

  void toggleWarningState() {
    setState(() {
      isWarning = !isWarning;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isWarning ? Colors.red : Colors.lightGreen;
    final String statusText = isWarning ? 'Warning' : 'No Warning';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: isWarning ? _buildWarningImage() : _buildSafeImage(),
                ),
              ),
              const SizedBox(height: 32),
              isWarning
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A cow is approaching\nyour farm !!!\nSafe it',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Take action',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        'Your farm is safe',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
              const SizedBox(height: 24),
              if (isWarning) ...[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Coming Now button pressed!');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'coming now',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    onPressed: () {
                      print('Play Sound button pressed!');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'play sound',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildWarningImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        warningImageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSafeImage() {
    return Center(
      child: Image.asset(
        'assets/img/safe_crops.png',
        color: Colors.black,
        height: 260,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.agriculture,
          size: 200,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1.0),
        ),
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(
              icon: Icons.chat_bubble_outline, label: 'Home', isSelected: true),
          _buildNavItem(icon: null, label: '', isSelected: false),
          _buildNavItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              isSelected: false),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData? icon,
    required String label,
    required bool isSelected,
  }) {
    final color = isSelected ? Colors.blue : Colors.grey[700];

    if (icon == null) return Container(width: 1);

    return GestureDetector(
      onTap: () {
        if (label == 'Home') {
          toggleWarningState();
        } else if (label == 'Settings') {
          // Navigate to SettingsScreen when Settings is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color, size: 24),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
