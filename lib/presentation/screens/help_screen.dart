import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/constants/app_colors.dart';

class HelpScreen extends StatelessWidget {
  static const List<Map<String, String>> faqs = [
    {
      'question': 'Como solicitar um serviço?',
      'answer': 'Vá até a aba Serviços e clique em "Solicitar" no serviço desejado.',
    },
    {
      'question': 'Quanto tempo demora um reparo?',
      'answer': 'O tempo varia conforme o tipo de serviço. Consulte a estimativa na descrição.',
    },
    {
      'question': 'Como acompanhar meu pedido?',
      'answer': 'Acesse "Histórico de Serviços" no seu perfil para ver o status.',
    },
  ];

  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajuda e Suporte'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.phone, color: AppColors.primaryPurple),
              title: Text('Telefone'),
              subtitle: Text('(11) 99999-9999'),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ligando para (11) 99999-9999')),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.email, color: AppColors.primaryPurple),
              title: Text('Email'),
              subtitle: Text('suporte@itech.com'),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Abrindo email para suporte@itech.com')),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('Perguntas Frequentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...faqs.map((faq) => ExpansionTile(
            title: Text(faq['question']!),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(faq['answer']!),
              ),
            ],
          )),
        ],
      ),
    );
  }
}