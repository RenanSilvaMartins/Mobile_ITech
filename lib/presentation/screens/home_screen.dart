import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_controller.dart';
import 'technicians_screen.dart';
import 'profile_screen.dart';
import 'services_screen.dart';
import 'service_history_screen.dart';
import 'agendamentos_screen.dart';
import '../../data/services/user_service.dart';
import '../../data/services/agendamento_service.dart';
import '../../data/models/agendamento_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    TechniciansScreen(),
    ServicesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            ),
          );
        },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryPurple,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering),
            label: 'Técnicos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Serviços',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  List<AgendamentoModel> _recentServices = [];
  bool _isLoadingServices = true;
  
  void _navigateToServices(String category) {
    final homeState = context.findAncestorStateOfType<_HomeScreenState>();
    if (homeState != null) {
      homeState.setState(() {
        homeState._currentIndex = 2;
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    _loadRecentServices();
  }

  Future<void> _loadRecentServices() async {
    try {
      final services = await AgendamentoService.listarTodos();
      setState(() {
        _recentServices = services.take(2).toList();
        _isLoadingServices = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingServices = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: AppColors.getBackground(isDark),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(24, 32, 24, 40),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Olá, ${UserService().currentUser?.name ?? 'Cliente'}!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Como podemos ajudar hoje?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                            homeState?.setState(() {
                              homeState._currentIndex = 3;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(Icons.person_outline, color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                        homeState?.setState(() {
                          homeState._currentIndex = 2;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search_rounded, color: Colors.white, size: 22),
                            SizedBox(width: 16),
                            Text(
                              'Buscar serviços...',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Quick Actions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Serviços Rápidos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(isDark),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            child: GestureDetector(
                              onTap: () => _navigateToServices('Smartphone'),
                              child: _QuickActionCard(
                                icon: Icons.phone_android,
                                title: 'Celular',
                                subtitle: 'Reparo de smartphones',
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            child: GestureDetector(
                              onTap: () => _navigateToServices('Notebook'),
                              child: _QuickActionCard(
                                icon: Icons.laptop,
                                title: 'Notebook',
                                subtitle: 'Manutenção de laptops',
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            child: GestureDetector(
                              onTap: () => _navigateToServices('Desktop'),
                              child: _QuickActionCard(
                                icon: Icons.desktop_windows,
                                title: 'Desktop',
                                subtitle: 'Reparo de PCs',
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AgendamentosScreen(),
                                  ),
                                );
                              },
                              child: _QuickActionCard(
                                icon: Icons.calendar_today,
                                title: 'Agendamentos',
                                subtitle: 'Ver agendamentos',
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Recent Services
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Agendamentos Recentes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.getTextPrimary(isDark),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => ServiceHistoryScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    )),
                                    child: child,
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 300),
                              ),
                            );
                          },
                          child: Text(
                            'Ver todos',
                            style: TextStyle(color: AppColors.primaryPurple),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (_isLoadingServices)
                      Center(child: CircularProgressIndicator())
                    else if (_recentServices.isEmpty)
                      Center(
                        child: Text(
                          'Nenhum agendamento encontrado',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    else
                      ..._recentServices.map((service) => 
                        _ServiceCard(
                          title: service.servicoTipo ?? service.servico,
                          technician: 'Técnico ${service.tecnicoId}',
                          status: service.status,
                          date: '${service.dataAgendamento.day}/${service.dataAgendamento.month}/${service.dataAgendamento.year}',
                          statusColor: service.status == 'Concluído' ? Colors.green : Colors.orange,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.getCardGradient(isDark),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: _isPressed ? 20 : 16,
                    offset: Offset(0, _isPressed ? 10 : 6),
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withOpacity(_isPressed ? 0.2 : 0.15),
                          widget.color.withOpacity(_isPressed ? 0.15 : 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 28),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getTextPrimary(isDark),
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.getTextSecondary(isDark),
                      fontWeight: FontWeight.w500,
                    ),
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

class _ServiceCard extends StatefulWidget {
  final String title;
  final String technician;
  final String status;
  final String date;
  final Color statusColor;

  const _ServiceCard({
    required this.title,
    required this.technician,
    required this.status,
    required this.date,
    required this.statusColor,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ServiceHistoryScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
      },
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getSurface(isDark),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
                    blurRadius: _isHovered ? 15 : 10,
                    offset: Offset(0, _isHovered ? 5 : 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(_isHovered ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.build, color: AppColors.primaryPurple),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextPrimary(isDark),
                          ),
                        ),
                        Text(
                          'Técnico: ${widget.technician}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.getTextSecondary(isDark),
                          ),
                        ),
                        Text(
                          widget.date,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.getTextTertiary(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.statusColor.withOpacity(_isHovered ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.status,
                      style: TextStyle(
                        color: widget.statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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

