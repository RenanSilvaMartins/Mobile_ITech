import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ServiceHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Reparo iPhone 12',
      'date': '15/12/2023',
      'status': 'Concluído',
      'price': 'R\$ 150,00',
      'technician': 'João Silva',
    },
    {
      'title': 'Formatação Notebook',
      'date': '18/12/2023',
      'status': 'Em andamento',
      'price': 'R\$ 80,00',
      'technician': 'Maria Santos',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Serviços'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(service['title']),
              subtitle: Text('${service['date']} - ${service['technician']}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(service['price'], style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(service['status'], style: TextStyle(color: service['status'] == 'Concluído' ? Colors.green : Colors.orange)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}