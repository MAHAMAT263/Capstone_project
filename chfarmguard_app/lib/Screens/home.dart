import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Your Raspberry Pi IP running Flask
const String raspberryPiIp = '192.168.1.242';
String get liveImageUrl =>
    'https://capstone-project-hbck.onrender.com/latest.jpg';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _imageUrl = liveImageUrl;
  bool automaticMode = false;

  @override
  void initState() {
    super.initState();
    _loadAutomaticMode();
  }

  Future<void> _loadAutomaticMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      automaticMode = prefs.getBool('automatic_mode') ?? false;
    });
  }

  /// Update alert status when buttons are clicked
  Future<void> _updateAlertStatus(
      BuildContext context, String alertId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('alerts')
          .doc(alertId)
          .update({'status': newStatus});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $newStatus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating alert: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('alerts')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildSafeView();
            }

            final doc = snapshot.data!.docs.first;
            final alertData = doc.data() as Map<String, dynamic>;
            final status = alertData['status'] ?? '';
            final isWarning = (status == 'PENDING');

            // AUTO PLAY SOUND IF AUTOMATIC MODE IS ON
            if (isWarning && automaticMode) {
              _updateAlertStatus(context, doc.id, 'PLAY');
            }

            // Only refresh image when there’s a new alert
            if (isWarning) {
              _imageUrl =
                  '$liveImageUrl?t=${DateTime.now().millisecondsSinceEpoch}';
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    isWarning ? 'Warning' : 'No Warning',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isWarning ? Colors.red : Colors.lightGreen,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 220,
                      child:
                          isWarning ? _buildWarningImage() : _buildSafeImage(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  isWarning
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'A ${alertData['animal'] ?? 'cattle'} is approaching\nyour farm !!!\nTake action now!',
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Take action',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _updateAlertStatus(
                                    context,
                                    doc.id,
                                    'NOT_PLAY',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                                onPressed: () async {
                                  await _updateAlertStatus(
                                    context,
                                    doc.id,
                                    'PLAY',
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  /// Build warning image (from Raspberry Pi)
  Widget _buildWarningImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        _imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.redAccent, size: 100),
      ),
    );
  }

  /// Build safe image (placeholder)
  Widget _buildSafeImage() {
    return Center(
      child: Image.asset(
        'assets/img/safe_crops.png',
        height: 260,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.agriculture, size: 200, color: Colors.black54),
      ),
    );
  }

  /// Bottom Navigation Bar
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            isSelected: true,
            onTap: () {},
          ),
          _buildNavItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            isSelected: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Navigation item builder
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? Colors.blue : Colors.grey[700];
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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

  /// Safe fallback view
  Widget _buildSafeView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.agriculture, size: 100, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Your farm is safe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
