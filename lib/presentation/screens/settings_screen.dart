import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  String _language = 'Português';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: Text('Modo Escuro'),
              subtitle: Text('Ativar tema escuro'),
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
              activeThumbColor: AppColors.primaryPurple,
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Idioma'),
              subtitle: Text(_language),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Selecionar Idioma'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Português'),
                          onTap: () {
                            setState(() => _language = 'Português');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('English'),
                          onTap: () {
                            setState(() => _language = 'English');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Sobre o App'),
              subtitle: Text('Versão 1.0.0'),
              trailing: Icon(Icons.info),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Flutter ITech',
                applicationVersion: '1.0.0',
                children: [Text('App de serviços técnicos')],
              ),
            ),
          ),
        ],
      ),
    );
  }
}