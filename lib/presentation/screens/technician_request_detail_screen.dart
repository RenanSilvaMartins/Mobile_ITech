import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'technician_chat_screen.dart';

class TechnicianRequestDetailScreen extends StatefulWidget {
  final Map<String, dynamic> request;

  const TechnicianRequestDetailScreen({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  State<TechnicianRequestDetailScreen> createState() => _TechnicianRequestDetailScreenState();
}

class _TechnicianRequestDetailScreenState extends State<TechnicianRequestDetailScreen> {
  String get _status => widget.request['status'];

  void _acceptRequest() {
    setState(() {
      widget.request['status'] = 'Aceita';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Solicitação aceita com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _startService() {
    setState(() {
      widget.request['status'] = 'Em Andamento';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Serviço iniciado!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _finishService() {
    setState(() {
      widget.request['status'] = 'Finalizada';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Serviço finalizado!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectRequest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rejeitar Solicitação'),
        content: Text('Tem certeza que deseja rejeitar esta solicitação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Solicitação rejeitada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Rejeitar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pendente':
        return Colors.orange;
      case 'Aceita':
        return Colors.blue;
      case 'Em Andamento':
        return Colors.green;
      case 'Finalizada':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Solicitação'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TechnicianChatScreen(
                    clientName: widget.request['clientName'],
                    requestId: widget.request['id'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(_status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _status,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      'R\$ ${widget.request['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Service Info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações do Serviço',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow(Icons.build, 'Serviço', widget.request['service']),
                    _buildInfoRow(Icons.description, 'Descrição', widget.request['description']),
                    _buildInfoRow(Icons.priority_high, 'Urgência', widget.request['urgency']),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Client Info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações do Cliente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow(Icons.person, 'Nome', widget.request['clientName']),
                    _buildInfoRow(Icons.location_on, 'Endereço', widget.request['location']),
                    _buildInfoRow(Icons.directions, 'Distância', widget.request['distance']),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            // Action Buttons
            if (_status == 'Pendente') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _rejectRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Rejeitar'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _acceptRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Aceitar Solicitação'),
                    ),
                  ),
                ],
              ),
            ] else if (_status == 'Aceita') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Iniciar Serviço'),
                ),
              ),
            ] else if (_status == 'Em Andamento') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _finishService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Finalizar Serviço'),
                ),
              ),
            ] else if (_status == 'Finalizada') ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Serviço Finalizado',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}