import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'technicians_screen.dart';
import 'profile_screen.dart';
import 'services_screen.dart';
import 'service_history_screen.dart';
import '../../data/services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: Colors.grey,
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
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  
  void _navigateToServices(String category) {
    final homeState = context.findAncestorStateOfType<_HomeScreenState>();
    if (homeState != null) {
      homeState.setState(() {
        homeState._currentIndex = 2;
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.modernGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
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
                            // Navegar para aba do perfil ao invés de push
                            final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                            homeState?.setState(() {
                              homeState._currentIndex = 3;
                            });
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Icon(Icons.person, color: Colors.white, size: 30),
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
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              'Buscar serviços...',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
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
                        color: Colors.grey[800],
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
                              onTap: () => _navigateToServices('Geral'),
                              child: _QuickActionCard(
                                icon: Icons.tablet,
                                title: 'Tablet',
                                subtitle: 'Assistência tablets',
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
                          'Serviços Recentes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
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
                    _ServiceCard(
                      title: 'Reparo iPhone 12',
                      technician: 'João Silva',
                      status: 'Concluído',
                      date: '15/12/2023',
                      statusColor: Colors.green,
                    ),
                    _ServiceCard(
                      title: 'Formatação Notebook',
                      technician: 'Maria Santos',
                      status: 'Em andamento',
                      date: '18/12/2023',
                      statusColor: Colors.orange,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_isPressed ? 0.1 : 0.05),
                    blurRadius: _isPressed ? 15 : 10,
                    offset: Offset(0, _isPressed ? 8 : 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(_isPressed ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 24),
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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
                color: Colors.white,
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
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          'Técnico: ${widget.technician}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          widget.date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
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