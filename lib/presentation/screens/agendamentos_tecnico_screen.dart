import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/agendamento_model.dart';
import '../../data/services/agendamento_service.dart';

class AgendamentosTecnicoScreen extends StatefulWidget {
  final String tecnicoId;
  final String tecnicoNome;

  const AgendamentosTecnicoScreen({
    super.key,
    required this.tecnicoId,
    required this.tecnicoNome,
  });

  @override
  State<AgendamentosTecnicoScreen> createState() => _AgendamentosTecnicoScreenState();
}

class _AgendamentosTecnicoScreenState extends State<AgendamentosTecnicoScreen> {
  List<AgendamentoModel> agendamentos = [];
  bool isLoading = true;
  DateTime? dataSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarAgendamentosTecnico();
  }

  Future<void> _carregarAgendamentosTecnico() async {
    setState(() => isLoading = true);
    try {
      final dados = await AgendamentoService.buscarPorTecnico(widget.tecnicoId);
      setState(() {
        agendamentos = dados;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar agendamentos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _carregarAgendamentosPorData(DateTime data) async {
    setState(() => isLoading = true);
    try {
      final dados = await AgendamentoService.buscarPorData(data);
      // Filtrar apenas os agendamentos do técnico específico
      final agendamentosFiltrados = dados.where((a) => a.tecnicoId == widget.tecnicoId).toList();
      setState(() {
        agendamentos = agendamentosFiltrados;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar agendamentos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Agendamentos - ${widget.tecnicoNome}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selecionarData,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (dataSelecionada != null) {
                _carregarAgendamentosPorData(dataSelecionada!);
              } else {
                _carregarAgendamentosTecnico();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtro de data
          if (dataSelecionada != null)
            Container(
              padding: EdgeInsets.all(16),
              color: AppColors.primaryPurple.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.filter_list, color: AppColors.primaryPurple),
                  SizedBox(width: 8),
                  Text(
                    'Filtrado por: ${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() => dataSelecionada = null);
                      _carregarAgendamentosTecnico();
                    },
                    child: Text('Limpar filtro'),
                  ),
                ],
              ),
            ),

          // Lista de agendamentos
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryPurple,
                    ),
                  )
                : agendamentos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              dataSelecionada != null
                                  ? 'Nenhum agendamento nesta data'
                                  : 'Nenhum agendamento encontrado',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () {
                          if (dataSelecionada != null) {
                            return _carregarAgendamentosPorData(dataSelecionada!);
                          } else {
                            return _carregarAgendamentosTecnico();
                          }
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: agendamentos.length,
                          itemBuilder: (context, index) {
                            final agendamento = agendamentos[index];
                            return _AgendamentoCard(agendamento: agendamento);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: dataSelecionada ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (data != null) {
      setState(() => dataSelecionada = data);
      _carregarAgendamentosPorData(data);
    }
  }
}

class _AgendamentoCard extends StatelessWidget {
  final AgendamentoModel agendamento;

  const _AgendamentoCard({required this.agendamento});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    agendamento.servico,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(agendamento.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    agendamento.status,
                    style: TextStyle(
                      color: _getStatusColor(agendamento.status),
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
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  '${agendamento.dataAgendamento.day}/${agendamento.dataAgendamento.month}/${agendamento.dataAgendamento.year} às ${agendamento.horario}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    agendamento.endereco,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (agendamento.descricao.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                agendamento.descricao,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Urgência: ${agendamento.urgencia}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  'R\$ ${agendamento.preco.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return Colors.orange;
      case 'confirmado':
        return Colors.blue;
      case 'em andamento':
        return Colors.purple;
      case 'concluído':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}