import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TechnicianEarningsScreen extends StatefulWidget {
  const TechnicianEarningsScreen({super.key});

  @override
  State<TechnicianEarningsScreen> createState() => _TechnicianEarningsScreenState();
}

class _TechnicianEarningsScreenState extends State<TechnicianEarningsScreen> {
  String _selectedPeriod = 'Hoje';

  final Map<String, Map<String, dynamic>> _earnings = {
    'Hoje': {
      'total': 450.0,
      'services': 3,
      'transactions': [
        {'service': 'Reparo de Notebook', 'client': 'João Silva', 'amount': 150.0, 'time': '14:30'},
        {'service': 'Instalação de Software', 'client': 'Maria Santos', 'amount': 80.0, 'time': '16:15'},
        {'service': 'Manutenção de PC', 'client': 'Pedro Costa', 'amount': 120.0, 'time': '18:45'},
      ],
    },
    'Esta Semana': {
      'total': 1250.0,
      'services': 8,
      'transactions': [
        {'service': 'Reparo de Notebook', 'client': 'João Silva', 'amount': 150.0, 'time': 'Hoje'},
        {'service': 'Formatação', 'client': 'Ana Lima', 'amount': 100.0, 'time': 'Ontem'},
        {'service': 'Troca de HD', 'client': 'Carlos Mendes', 'amount': 200.0, 'time': '2 dias atrás'},
      ],
    },
    'Este Mês': {
      'total': 3800.0,
      'services': 25,
      'transactions': [
        {'service': 'Reparo de Notebook', 'client': 'João Silva', 'amount': 150.0, 'time': 'Hoje'},
        {'service': 'Montagem de PC', 'client': 'Roberto Silva', 'amount': 300.0, 'time': '1 semana atrás'},
        {'service': 'Recuperação de Dados', 'client': 'Lucia Santos', 'amount': 250.0, 'time': '2 semanas atrás'},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentData = _earnings[_selectedPeriod]!;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Hoje', 'Esta Semana', 'Este Mês']
                  .map((period) => Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(period),
                          selected: _selectedPeriod == period,
                          onSelected: (selected) {
                            setState(() {
                              _selectedPeriod = period;
                            });
                          },
                          selectedColor: AppColors.primaryPurple.withOpacity(0.2),
                          checkmarkColor: AppColors.primaryPurple,
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 20),
          // Earnings Summary
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.modernGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.attach_money, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Total Ganho',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'R\$ ${currentData['total'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${currentData['services']} serviços',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Média por Serviço',
                  'R\$ ${(currentData['total'] / currentData['services']).toStringAsFixed(2)}',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Serviços Realizados',
                  '${currentData['services']}',
                  Icons.build,
                  Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Payment Actions
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ações de Pagamento',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showWithdrawDialog();
                          },
                          icon: Icon(Icons.account_balance_wallet),
                          label: Text('Sacar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showPaymentHistoryDialog();
                          },
                          icon: Icon(Icons.history),
                          label: Text('Histórico'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryPurple,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Recent Transactions
          Text(
            'Transações Recentes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ...currentData['transactions'].map<Widget>((transaction) {
            return Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.build,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ),
                title: Text(
                  transaction['service'],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(transaction['client']),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${transaction['amount'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      transaction['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawDialog() {
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Solicitar Saque'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Saldo disponível: R\$ ${_earnings[_selectedPeriod]!['total'].toStringAsFixed(2)}'),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor do saque',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Solicitação de saque enviada!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Solicitar'),
          ),
        ],
      ),
    );
  }

  void _showPaymentHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Histórico de Pagamentos'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Saque realizado'),
                subtitle: Text('15/01/2024'),
                trailing: Text('R\$ 500,00'),
              ),
              ListTile(
                leading: Icon(Icons.pending, color: Colors.orange),
                title: Text('Saque pendente'),
                subtitle: Text('20/01/2024'),
                trailing: Text('R\$ 300,00'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }
}