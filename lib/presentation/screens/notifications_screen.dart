import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: Text('Notificações Push'),
              subtitle: Text('Receber notificações no dispositivo'),
              value: _pushNotifications,
              onChanged: (value) => setState(() => _pushNotifications = value),
              thumbColor: WidgetStateProperty.all(AppColors.primaryPurple),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: Text('Notificações por Email'),
              subtitle: Text('Receber atualizações por email'),
              value: _emailNotifications,
              onChanged: (value) => setState(() => _emailNotifications = value),
              thumbColor: WidgetStateProperty.all(AppColors.primaryPurple),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: Text('Notificações SMS'),
              subtitle: Text('Receber SMS sobre serviços'),
              value: _smsNotifications,
              onChanged: (value) => setState(() => _smsNotifications = value),
              thumbColor: WidgetStateProperty.all(AppColors.primaryPurple),
            ),
          ),
        ],
      ),
    );
  }
}