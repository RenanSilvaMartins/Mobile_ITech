import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/agendamento_model.dart';
import '../../data/services/agendamento_service.dart';

class EditarAgendamentoScreen extends StatefulWidget {
  final String agendamentoId;

  const EditarAgendamentoScreen({
    super.key,
    required this.agendamentoId,
  });

  @override
  State<EditarAgendamentoScreen> createState() => _EditarAgendamentoScreenState();
}

class _EditarAgendamentoScreenState extends State<EditarAgendamentoScreen> {
  AgendamentoModel? agendamento;
  bool isLoading = true;
  bool isSaving = false;

  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _enderecoController = TextEditingController();
  
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedUrgency;
  double? selectedPrice;

  final List<String> urgencyLevels = ['Normal', 'Urgente', 'Emergência'];

  @override
  void initState() {
    super.initState();
    _carregarAgendamento();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  Future<void> _carregarAgendamento() async {
    try {
      final agendamentoCarregado = await AgendamentoService.buscarPorId(widget.agendamentoId);
      setState(() {
        agendamento = agendamentoCarregado;
        _descricaoController.text = agendamentoCarregado.descricao;
        _enderecoController.text = agendamentoCarregado.endereco;
        selectedDate = agendamentoCarregado.dataAgendamento;
        
        // Converter horário string para TimeOfDay
        final horarioParts = agendamentoCarregado.horario.split(':');
        selectedTime = TimeOfDay(
          hour: int.parse(horarioParts[0]),
          minute: int.parse(horarioParts[1]),
        );
        
        selectedUrgency = agendamentoCarregado.urgencia;
        selectedPrice = agendamentoCarregado.preco;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar agendamento: $e'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      final agendamentoAtualizado = AgendamentoModel(
        id: agendamento!.id,
        usuarioId: agendamento!.usuarioId,
        tecnicoId: agendamento!.tecnicoId,
        servico: agendamento!.servico,
        descricao: _descricaoController.text,
        endereco: _enderecoController.text,
        dataAgendamento: selectedDate!,
        horario: '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
        urgencia: selectedUrgency!,
        preco: selectedPrice!,
        status: agendamento!.status,
        createdAt: agendamento!.createdAt,
        updatedAt: DateTime.now(),
      );

      await AgendamentoService.atualizar(widget.agendamentoId, agendamentoAtualizado);
      
      setState(() => isSaving = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Agendamento atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, true); // Retorna true indicando que houve alteração
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar agendamento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('Carregando...'),
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryPurple),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Editar Agendamento',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (isSaving)
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _salvarAlteracoes,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações não editáveis
              Container(
                padding: EdgeInsets.all(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações do Serviço',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    _InfoItem('Serviço', agendamento!.servico),
                    _InfoItem('Status', agendamento!.status),
                    _InfoItem('ID', agendamento!.id ?? 'N/A'),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Data e horário
              Text(
                'Data e Horário',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DateTimeCard(
                      title: 'Data',
                      value: selectedDate != null 
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Selecionar',
                      icon: Icons.calendar_today,
                      onTap: _selectDate,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _DateTimeCard(
                      title: 'Horário',
                      value: selectedTime != null 
                          ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                          : 'Selecionar',
                      icon: Icons.access_time,
                      onTap: _selectTime,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Urgência
              Text(
                'Nível de Urgência',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedUrgency,
                    isExpanded: true,
                    hint: Text('Selecione a urgência'),
                    items: urgencyLevels.map((urgency) {
                      return DropdownMenuItem(
                        value: urgency,
                        child: Text(urgency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedUrgency = value);
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Preço
              Text(
                'Preço',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: selectedPrice?.toStringAsFixed(2),
                decoration: InputDecoration(
                  hintText: 'Digite o preço',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o preço';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Digite um preço válido';
                  }
                  return null;
                },
                onChanged: (value) {
                  selectedPrice = double.tryParse(value);
                },
              ),
              SizedBox(height: 24),

              // Endereço
              Text(
                'Endereço do Atendimento',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(
                  hintText: 'Digite o endereço completo',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o endereço';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Descrição
              Text(
                'Descrição do Problema',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  hintText: 'Descreva detalhadamente o problema...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a descrição';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

              // Botão salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _salvarAlteracoes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSaving
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Salvando...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Salvar Alterações',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTimeCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _DateTimeCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primaryPurple),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}