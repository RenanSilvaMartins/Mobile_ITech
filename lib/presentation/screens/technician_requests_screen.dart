import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'technician_request_detail_screen.dart';

class TechnicianRequestsScreen extends StatefulWidget {
  const TechnicianRequestsScreen({Key? key}) : super(key: key);

  @override
  State<TechnicianRequestsScreen> createState() => _TechnicianRequestsScreenState();
}

class _TechnicianRequestsScreenState extends State<TechnicianRequestsScreen> {
  String _selectedFilter = 'Todas';

  final List<Map<String, dynamic>> _requests = [
    {
      'id': '1',
      'clientName': 'João Silva',
      'service': 'Reparo de Notebook',
      'description': 'Notebook não liga, possível problema na fonte',
      'location': 'Rua das Flores, 123',
      'price': 150.0,
      'status': 'Pendente',
      'urgency': 'Alta',
      'distance': '2.5 km',
      'createdAt': DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      'id': '2',
      'clientName': 'Maria Santos',
      'service': 'Instalação de Software',
      'description': 'Instalar pacote Office e antivírus',
      'location': 'Av. Principal, 456',
      'price': 80.0,
      'status': 'Aceita',
      'urgency': 'Média',
      'distance': '1.2 km',
      'createdAt': DateTime.now().subtract(Duration(hours: 5)),
    },
    {
      'id': '3',
      'clientName': 'Pedro Costa',
      'service': 'Manutenção de PC',
      'description': 'Limpeza geral e troca de pasta térmica',
      'location': 'Rua do Comércio, 789',
      'price': 120.0,
      'status': 'Em Andamento',
      'urgency': 'Baixa',
      'distance': '3.8 km',
      'createdAt': DateTime.now().subtract(Duration(days: 1)),
    },
  ];

  List<Map<String, dynamic>> get _filteredRequests {
    if (_selectedFilter == 'Todas') return _requests;
    return _requests.where((request) => request['status'] == _selectedFilter).toList();
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

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'Alta':
        return Colors.red;
      case 'Média':
        return Colors.orange;
      case 'Baixa':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filtros
        Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Todas', 'Pendente', 'Aceita', 'Em Andamento', 'Finalizada']
                  .map((filter) => Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          selectedColor: AppColors.primaryPurple.withOpacity(0.2),
                          checkmarkColor: AppColors.primaryPurple,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        // Lista de solicitações
        Expanded(
          child: _filteredRequests.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Nenhuma solicitação encontrada',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = _filteredRequests[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TechnicianRequestDetailScreen(
                                request: request,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      request['service'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(request['status']),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      request['status'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                                  SizedBox(width: 4),
                                  Text(
                                    request['clientName'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getUrgencyColor(request['urgency']),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      request['urgency'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                request['description'],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${request['location']} • ${request['distance']}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'R\$ ${request['price'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: AppColors.primaryPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}