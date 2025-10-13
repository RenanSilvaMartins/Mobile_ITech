import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/agendamento_service.dart';
import '../../data/models/agendamento_model.dart';
import '../../controllers/technician_controller.dart';
import '../../controllers/service_controller.dart';
import '../../data/models/technician_model.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _cardAnimationControllers;
  
  List<AgendamentoModel> services = [];
  bool _isLoading = true;
  final Map<String, String> _technicianNames = {};
  final Map<String, String> _serviceNames = {};
  final Map<String, String> _serviceTypes = {};

  @override
  void initState() {
    super.initState();
    _loadServices();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
  }

  Future<void> _loadServices() async {
    try {
      final loadedServices = await AgendamentoService.listarTodos();
      await _loadTechnicianNames(loadedServices);
      await _loadServiceNames();
      
      setState(() {
        services = loadedServices;
        _isLoading = false;
      });
      
      _cardAnimationControllers = List.generate(
        services.length,
        (index) => AnimationController(
          duration: Duration(milliseconds: 300),
          vsync: this,
        ),
      );
      
      _animationController.forward();
      
      // Animar cards com delay
      for (int i = 0; i < _cardAnimationControllers.length; i++) {
        Future.delayed(Duration(milliseconds: 100 * i), () {
          if (mounted) {
            _cardAnimationControllers[i].forward();
          }
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTechnicianNames(List<AgendamentoModel> agendamentos) async {
    try {
      final technicians = await TechnicianController.getAllTechnicians();
      print('Técnicos carregados: ${technicians.length}');
      
      for (var agendamento in agendamentos) {
        print('Procurando técnico com ID: ${agendamento.tecnicoId}');
        
        final technician = technicians.firstWhere(
          (tech) {
            print('Comparando: ${tech.id} com ${agendamento.tecnicoId}');
            return tech.id.toString() == agendamento.tecnicoId;
          },
          orElse: () {
            print('Técnico não encontrado para ID: ${agendamento.tecnicoId}');
            return TechnicianModel(
              id: 0,
              cpfCnpj: '',
              dataNascimento: '',
              telefone: '',
              cep: '',
              numeroResidencia: '',
              complemento: '',
              descricao: '',
              especialidade: '',
              usuarioId: 0,
              statusTecnico: '',
              name: 'Técnico ID ${agendamento.tecnicoId}',
              email: '',
            );
          },
        );
        _technicianNames[agendamento.tecnicoId] = technician.name;
        print('Nome do técnico salvo: ${technician.name}');
      }
    } catch (e) {
      print('Erro ao carregar nomes dos técnicos: $e');
    }
  }

  Future<void> _loadServiceNames() async {
    try {
      final servicesList = await ServiceController.getAllServices();
      for (var service in servicesList) {
        _serviceNames[service.id.toString()] = service.name;
        _serviceTypes[service.id.toString()] = service.tipo;
      }
    } catch (e) {
      print('Erro ao carregar nomes dos serviços: $e');
    }
  }

  IconData _getServiceIcon(String service) {
    if (service.toLowerCase().contains('celular') || service.toLowerCase().contains('smartphone')) {
      return Icons.phone_android;
    } else if (service.toLowerCase().contains('notebook') || service.toLowerCase().contains('laptop')) {
      return Icons.laptop;
    } else if (service.toLowerCase().contains('desktop') || service.toLowerCase().contains('computador')) {
      return Icons.desktop_windows;
    } else if (service.toLowerCase().contains('tv') || service.toLowerCase().contains('televisão')) {
      return Icons.tv;
    } else {
      return Icons.build;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _cardAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Histórico de Agendamentos',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _animationController,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              )),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : services.isEmpty
                      ? Center(
                          child: Text(
                            'Nenhum agendamento encontrado',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            return AnimatedBuilder(
                              animation: _cardAnimationControllers[index],
                              builder: (context, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(1, 0),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: _cardAnimationControllers[index],
                                    curve: Curves.easeInOut,
                                  )),
                                  child: FadeTransition(
                                    opacity: _cardAnimationControllers[index],
                                    child: _ServiceHistoryCard(
                                      title: service.descricao.isNotEmpty ? service.descricao : 'Sem descrição adicional',
                                      date: '${service.dataAgendamento.day.toString().padLeft(2, '0')}/${service.dataAgendamento.month.toString().padLeft(2, '0')}/${service.dataAgendamento.year}',
                                      status: service.status,
                                      price: 'R\$ ${service.preco.toStringAsFixed(2)}',
                                      technician: _technicianNames[service.tecnicoId] ?? 'Técnico ${service.tecnicoId}',
                                      description: service.servicoTipo ?? '',
                                      icon: _getServiceIcon(_serviceNames[service.servicoId ?? ''] ?? service.servico),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          );
        },
      ),
    );
  }
}

class _ServiceHistoryCard extends StatefulWidget {
  final String title;
  final String date;
  final String status;
  final String price;
  final String technician;
  final String description;
  final IconData icon;

  const _ServiceHistoryCard({
    required this.title,
    required this.date,
    required this.status,
    required this.price,
    required this.technician,
    required this.description,
    required this.icon,
  });

  @override
  State<_ServiceHistoryCard> createState() => _ServiceHistoryCardState();
}

class _ServiceHistoryCardState extends State<_ServiceHistoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  Color get statusColor {
    switch (widget.status.toLowerCase()) {
      case 'concluído':
        return Colors.green;
      case 'em andamento':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
                    blurRadius: _isHovered ? 20 : 10,
                    offset: Offset(0, _isHovered ? 8 : 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(_isHovered ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.icon,
                      color: AppColors.primaryPurple,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primaryPurple.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person, size: 16, color: Colors.grey[500]),
                            SizedBox(width: 4),
                            Text(
                              widget.technician,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                            SizedBox(width: 4),
                            Text(
                              widget.date,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.price,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      SizedBox(height: 8),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(_isHovered ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}