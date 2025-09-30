import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/service_model.dart';
import '../../controllers/service_controller.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});
  
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  List<ServiceModel> _allServices = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      print('Carregando serviços da API: http://localhost:8082/servico');
      final services = await ServiceController.getAllServices();
      print('Serviços carregados: ${services.length}');
      
      if (mounted) {
        setState(() {
          _allServices = services;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro detalhado: $e');
      if (mounted) {
        setState(() {
          _allServices = [];
          _errorMessage = 'Falha ao conectar com o servidor. Verifique se a API está rodando em http://localhost:8082/servico';
          _isLoading = false;
        });
      }
    }
  }
  
  final Map<String, IconData> _categoryIcons = {
    'Smartphone': Icons.phone_android,
    'Notebook': Icons.laptop,
    'Desktop': Icons.desktop_windows,
    'Geral': Icons.build,
  };

  List<ServiceModel> get _filteredServices {
    List<ServiceModel> filtered = _allServices;
    
    if (_selectedCategory != 'Todos') {
      filtered = filtered.where((service) => 
        service.category == _selectedCategory
      ).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((service) => 
        service.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (service.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
        service.category.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Nossos Serviços',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.textTertiary),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar serviço...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Category Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CategoryChip('Todos', _selectedCategory == 'Todos', (selected) {
                    setState(() { _selectedCategory = 'Todos'; });
                  }),
                  _CategoryChip('Smartphone', _selectedCategory == 'Smartphone', (selected) {
                    setState(() { _selectedCategory = 'Smartphone'; });
                  }),
                  _CategoryChip('Notebook', _selectedCategory == 'Notebook', (selected) {
                    setState(() { _selectedCategory = 'Notebook'; });
                  }),
                  _CategoryChip('Desktop', _selectedCategory == 'Desktop', (selected) {
                    setState(() { _selectedCategory = 'Desktop'; });
                  }),
                  _CategoryChip('Geral', _selectedCategory == 'Geral', (selected) {
                    setState(() { _selectedCategory = 'Geral'; });
                  }),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Services Grid
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 64, color: AppColors.primaryRed),
                              SizedBox(height: 16),
                              Text(
                                'Erro ao carregar serviços',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _loadServices,
                                child: Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        )
                      : _filteredServices.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 64, color: AppColors.textTertiary),
                                  SizedBox(height: 16),
                                  Text(
                                    'Nenhum serviço encontrado',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                  : AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 0.1),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            )),
                            child: child,
                          ),
                        );
                      },
                      child: GridView.builder(
                        key: ValueKey(_selectedCategory + _searchQuery),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _filteredServices.length,
                        itemBuilder: (context, index) {
                          final service = _filteredServices[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 200 + (index * 50)),
                            curve: Curves.easeInOut,
                            child: _ServiceCard(
                              service: service,
                              icon: _categoryIcons[service.category] ?? Icons.build,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  final String label;
  final bool selected;
  final Function(bool) onSelected;

  const _CategoryChip(this.label, this.selected, this.onSelected);

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTapDown: (_) => _animationController.forward(),
              onTapUp: (_) => _animationController.reverse(),
              onTapCancel: () => _animationController.reverse(),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                child: FilterChip(
                  label: Text(widget.label),
                  selected: widget.selected,
                  onSelected: widget.onSelected,
                  selectedColor: AppColors.primaryPurple.withOpacity(0.2),
                  checkmarkColor: AppColors.primaryPurple,
                  backgroundColor: AppColors.surface,
                  elevation: widget.selected ? 2 : 0,
                  shadowColor: AppColors.primaryPurple.withOpacity(0.3),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final ServiceModel service;
  final IconData icon;

  const _ServiceCard({
    required this.service,
    required this.icon,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> with SingleTickerProviderStateMixin {
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
      end: 0.98,
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

  void _showServiceDialog() {
    Navigator.pushNamed(
      context,
      '/technicians',
      arguments: {
        'selectedService': widget.service,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isPressed ? 0.1 : 0.05),
                  blurRadius: _isPressed ? 15 : 10,
                  offset: Offset(0, _isPressed ? 8 : 5),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withOpacity(_isPressed ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(widget.icon, color: AppColors.primaryPurple, size: 24),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isPressed ? Colors.grey[300] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.service.category,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.service.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.service.description ?? 'Serviço de ${widget.service.category}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: AppColors.textTertiary),
                      SizedBox(width: 4),
                      Text(
                        widget.service.duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ ${widget.service.price.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() => _isPressed = true);
                          _animationController.forward();
                        },
                        onTapUp: (_) {
                          setState(() => _isPressed = false);
                          _animationController.reverse();
                          _showServiceDialog();
                        },
                        onTapCancel: () {
                          setState(() => _isPressed = false);
                          _animationController.reverse();
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isPressed ? AppColors.primaryPurple.withOpacity(0.8) : AppColors.primaryPurple,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryPurple.withOpacity(0.3),
                                blurRadius: _isPressed ? 8 : 4,
                                offset: Offset(0, _isPressed ? 4 : 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'Solicitar',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
    );
  }
}