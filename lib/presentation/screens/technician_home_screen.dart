import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/constants/app_colors.dart';
import 'technician_requests_screen.dart';
import 'technician_profile_screen.dart';

class TechnicianHomeScreen extends StatefulWidget {
  const TechnicianHomeScreen({super.key});

  @override
  State<TechnicianHomeScreen> createState() => _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends State<TechnicianHomeScreen> {
  int _currentIndex = 0;
  bool _isOnline = true;

  final List<Widget> _screens = [
    TechnicianRequestsScreen(),
    TechnicianProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Área do Técnico'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text(
                  _isOnline ? 'Online' : 'Offline',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(width: 8),
                Switch(
                  value: _isOnline,
                  onChanged: (value) {
                    setState(() {
                      _isOnline = value;
                    });
                  },
                  thumbColor: WidgetStateProperty.all(Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Solicitações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}