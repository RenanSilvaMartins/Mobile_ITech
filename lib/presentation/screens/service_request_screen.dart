import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/agendamento_model.dart';
import '../../data/models/service_model.dart';
import '../../data/services/agendamento_service.dart';

class ServiceRequestScreen extends StatefulWidget {
  final Map<String, dynamic> technician;
  final ServiceModel? selectedService;

  const ServiceRequestScreen({super.key, required this.technician, this.selectedService});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  String? selectedService;
  String? selectedUrgency;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final List<Map<String, dynamic>> services = [
    {'name': 'Reparo de Tela', 'price': 150.0, 'duration': '2-3h'},
    {'name': 'Troca de Bateria', 'price': 120.0, 'duration': '1h'},
    {'name': 'Formatação', 'price': 80.0, 'duration': '1-2h'},
    {'name': 'Limpeza Interna', 'price': 60.0, 'duration': '1h'},
    {'name': 'Recuperação de Dados', 'price': 200.0, 'duration': '2-4h'},
    {'name': 'Instalação de Software', 'price': 40.0, 'duration': '30min'},
  ];

  final List<Map<String, String>> urgencyLevels = [
    {'level': 'Normal', 'description': 'Até 2 dias úteis', 'extra': '0'},
    {'level': 'Urgente', 'description': 'Até 24 horas', 'extra': '20'},
    {'level': 'Emergência', 'description': 'Até 4 horas', 'extra': '50'},
  ];

  double get totalPrice {
    if (selectedService == null || selectedUrgency == null) return 0;
    
    final service = services.firstWhere((s) => s['name'] == selectedService);
    final urgency = urgencyLevels.firstWhere((u) => u['level'] == selectedUrgency);
    
    return service['price'] + double.parse(urgency['extra']!);
  }

  @override
  void initState() {
    super.initState();
    // Se há um serviço pré-selecionado, define ele como selecionado
    if (widget.selectedService != null) {
      selectedService = widget.selectedService!.name;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Solicitar Serviço',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Técnico selecionado
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(widget.technician['image']),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.technician['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.technician['specialty'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              widget.technician['rating'].toString(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Seleção de serviço
            Row(
              children: [
                Text(
                  'Selecione o Serviço',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                if (widget.selectedService != null) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Pré-selecionado',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 12),
            ...services.map((service) => _ServiceOption(
              name: service['name'],
              price: service['price'],
              duration: service['duration'],
              isSelected: selectedService == service['name'],
              onTap: () => setState(() => selectedService = service['name']),
              isPreSelected: widget.selectedService?.name == service['name'],
            )),
            SizedBox(height: 24),

            // Nível de urgência
            Text(
              'Nível de Urgência',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            ...urgencyLevels.map((urgency) => _UrgencyOption(
              level: urgency['level']!,
              description: urgency['description']!,
              extra: urgency['extra']!,
              isSelected: selectedUrgency == urgency['level'],
              onTap: () => setState(() => selectedUrgency = urgency['level']),
            )),
            SizedBox(height: 24),

            // Data e hora
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
                    onTap: () => _selectDate(),
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
                    onTap: () => _selectTime(),
                  ),
                ),
              ],
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
            TextField(
              controller: _addressController,
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
            ),
            SizedBox(height: 24),

            // Descrição do problema
            Text(
              'Descrição do Problema',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
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
            ),
            SizedBox(height: 24),

            // Resumo e botão de continuar
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (selectedService != null && selectedUrgency != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total do Serviço:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'R\$ ${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canProceed() ? _proceedToPayment : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canProceed() ? AppColors.primaryPurple : Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Finalizar Solicitação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    return selectedService != null &&
           selectedUrgency != null &&
           selectedDate != null &&
           selectedTime != null &&
           _addressController.text.trim().isNotEmpty &&
           _descriptionController.text.trim().isNotEmpty;
  }

  void _proceedToPayment() async {
    try {
      // Criar agendamento
      final agendamento = AgendamentoModel(
        usuarioId: '1', // Substituir pelo ID do usuário logado
        tecnicoId: widget.technician['id']?.toString() ?? '1',
        servico: selectedService!,
        descricao: _descriptionController.text,
        endereco: _addressController.text,
        dataAgendamento: selectedDate!,
        horario: '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
        urgencia: selectedUrgency!,
        preco: totalPrice,
      );

      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(color: AppColors.primaryPurple),
        ),
      );

      // Criar agendamento na API
      await AgendamentoService.criar(agendamento);
      
      // Fechar loading
      Navigator.pop(context);

      // Mostrar sucesso e voltar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Solicitação enviada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Voltar para tela anterior
      Navigator.pop(context);
    } catch (e) {
      // Fechar loading se estiver aberto
      if (Navigator.canPop(context)) Navigator.pop(context);
      
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao criar agendamento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
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
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }
}

class _ServiceOption extends StatelessWidget {
  final String name;
  final double price;
  final String duration;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isPreSelected;

  const _ServiceOption({
    required this.name,
    required this.price,
    required this.duration,
    required this.isSelected,
    required this.onTap,
    this.isPreSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryPurple : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: isPreSelected ? [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ] : null,
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            if (isPreSelected) ...[
              SizedBox(width: 8),
              Icon(
                Icons.star,
                size: 16,
                color: AppColors.primaryPurple,
              ),
            ],
          ],
        ),
        subtitle: Text('Duração: $duration'),
        trailing: Text(
          'R\$ ${price.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryPurple,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _UrgencyOption extends StatelessWidget {
  final String level;
  final String description;
  final String extra;
  final bool isSelected;
  final VoidCallback onTap;

  const _UrgencyOption({
    required this.level,
    required this.description,
    required this.extra,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryPurple : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: ListTile(
        title: Text(
          level,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
        trailing: Text(
          extra == '0' ? 'Grátis' : '+R\$ $extra',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: extra == '0' ? Colors.green : Colors.orange,
          ),
        ),
        onTap: onTap,
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