import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/agendamento_model.dart';
import '../../data/services/agendamento_service.dart';
import 'editar_agendamento_screen.dart';

class AgendamentosScreen extends StatefulWidget {
  const AgendamentosScreen({super.key});

  @override
  State<AgendamentosScreen> createState() => _AgendamentosScreenState();
}

class _AgendamentosScreenState extends State<AgendamentosScreen> {
  List<AgendamentoModel> agendamentos = [];
  bool isLoading = true;
  String filtroAtual = 'todos';

  @override
  void initState() {
    super.initState();
    _carregarAgendamentos();
  }

  Future<void> _carregarAgendamentos() async {
    setState(() => isLoading = true);
    try {
      List<AgendamentoModel> dados;
      switch (filtroAtual) {
        case 'usuario':
          dados = await AgendamentoService.buscarPorUsuario('1'); // ID do usuário logado
          break;
        case 'hoje':
          dados = await AgendamentoService.buscarPorData(DateTime.now());
          break;
        default:
          dados = await AgendamentoService.listarTodos();
      }
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: AppColors.getBackground(isDark),
      appBar: AppBar(
        title: Text(
          'Meus Agendamentos',
          style: TextStyle(
            color: AppColors.getSurface(isDark),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _carregarAgendamentos,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _FiltroChip(
                    label: 'Todos',
                    isSelected: filtroAtual == 'todos',
                    onTap: () => _aplicarFiltro('todos'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _FiltroChip(
                    label: 'Meus',
                    isSelected: filtroAtual == 'usuario',
                    onTap: () => _aplicarFiltro('usuario'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _FiltroChip(
                    label: 'Hoje',
                    isSelected: filtroAtual == 'hoje',
                    onTap: () => _aplicarFiltro('hoje'),
                  ),
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
                              Icons.calendar_today,
                              size: 64,
                              color: AppColors.getTextTertiary(isDark),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Nenhum agendamento encontrado',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.getTextSecondary(isDark),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _carregarAgendamentos,
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: agendamentos.length,
                          itemBuilder: (context, index) {
                            final agendamento = agendamentos[index];
                            return _AgendamentoCard(
                              agendamento: agendamento,
                              onTap: () => _verDetalhes(agendamento),
                              onDelete: () => _deletarAgendamento(agendamento.id!),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _aplicarFiltro(String filtro) {
    setState(() => filtroAtual = filtro);
    _carregarAgendamentos();
  }

  void _verDetalhes(AgendamentoModel agendamento) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DetalhesAgendamento(agendamento: agendamento),
    );
  }

  Future<void> _deletarAgendamento(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text('Deseja realmente cancelar este agendamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirmar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await AgendamentoService.deletar(id);
        _carregarAgendamentos();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Agendamento cancelado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cancelar agendamento: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _FiltroChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _AgendamentoCard extends StatelessWidget {
  final AgendamentoModel agendamento;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AgendamentoCard({
    required this.agendamento,
    required this.onTap,
    required this.onDelete,
  });

  void _editarAgendamento(BuildContext context) async {
    if (agendamento.id != null) {
      final resultado = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditarAgendamentoScreen(
            agendamentoId: agendamento.id!,
          ),
        ),
      );
      
      if (resultado == true) {
        final agendamentosState = context.findAncestorStateOfType<_AgendamentosScreenState>();
        agendamentosState?._carregarAgendamentos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDark),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          agendamento.servicoTipo ?? agendamento.servico,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              '${agendamento.dataAgendamento.day}/${agendamento.dataAgendamento.month}/${agendamento.dataAgendamento.year} às ${agendamento.horario}',
              style: TextStyle(color: AppColors.getTextSecondary(isDark)),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                Spacer(),
                Text(
                  'R\$ ${agendamento.preco.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'detalhes',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 20),
                  SizedBox(width: 8),
                  Text('Ver detalhes'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Editar', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'cancelar',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Cancelar', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'detalhes') {
              onTap();
            } else if (value == 'editar') {
              _editarAgendamento(context);
            } else if (value == 'cancelar') {
              onDelete();
            }
          },
        ),
        onTap: onTap,
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

class _DetalhesAgendamento extends StatelessWidget {
  final AgendamentoModel agendamento;

  const _DetalhesAgendamento({required this.agendamento});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDark),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.getDivider(isDark),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Detalhes do Agendamento',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20),
          _DetalheItem('Serviço', agendamento.servicoTipo ?? agendamento.servico),
          _DetalheItem('Data', '${agendamento.dataAgendamento.day}/${agendamento.dataAgendamento.month}/${agendamento.dataAgendamento.year}'),
          _DetalheItem('Horário', agendamento.horario),
          _DetalheItem('Endereço', agendamento.endereco),
          _DetalheItem('Urgência', agendamento.urgencia),
          _DetalheItem('Preço', 'R\$ ${agendamento.preco.toStringAsFixed(2)}'),
          _DetalheItem('Status', agendamento.status),
          if (agendamento.descricao.isNotEmpty)
            _DetalheItem('Descrição', agendamento.descricao),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Fechar',
                style: TextStyle(
                  color: AppColors.getSurface(isDark),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetalheItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetalheItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.getTextSecondary(isDark),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}