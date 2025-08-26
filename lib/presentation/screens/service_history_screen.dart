import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ServiceHistoryScreen extends StatefulWidget {
  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _cardAnimationControllers;
  
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Reparo iPhone 12',
      'date': '15/12/2023',
      'status': 'Concluído',
      'price': 'R\$ 150,00',
      'technician': 'João Silva',
      'description': 'Troca de tela e bateria',
      'icon': Icons.phone_android,
    },
    {
      'title': 'Formatação Notebook',
      'date': '18/12/2023',
      'status': 'Em andamento',
      'price': 'R\$ 80,00',
      'technician': 'Maria Santos',
      'description': 'Formatação completa do sistema',
      'icon': Icons.laptop,
    },
    {
      'title': 'Reparo Desktop',
      'date': '10/12/2023',
      'status': 'Concluído',
      'price': 'R\$ 120,00',
      'technician': 'Carlos Lima',
      'description': 'Troca de fonte e limpeza',
      'icon': Icons.desktop_windows,
    },
    {
      'title': 'Recuperação de Dados',
      'date': '05/12/2023',
      'status': 'Concluído',
      'price': 'R\$ 200,00',
      'technician': 'Ana Costa',
      'description': 'Recuperação de HD danificado',
      'icon': Icons.storage,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
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
          'Histórico de Serviços',
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
              child: ListView.builder(
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
                            title: service['title'],
                            date: service['date'],
                            status: service['status'],
                            price: service['price'],
                            technician: service['technician'],
                            description: service['description'],
                            icon: service['icon'],
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
                        SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
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