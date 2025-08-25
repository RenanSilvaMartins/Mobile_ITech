import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajuda e Suporte'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Central de ajuda em desenvolvimento'),
      ),
    );
  }
}