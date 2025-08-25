import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ServiceHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Serviços'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Histórico de Serviços em desenvolvimento'),
      ),
    );
  }
}