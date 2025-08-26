import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);
  
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _allServices = [
    {
      'title': 'Reparo de Tela',
      'description': 'Troca de tela quebrada ou com defeito',
      'price': 'R\$ 150,00',
      'duration': '2-3 horas',
      'icon': Icons.phone_android,
      'category': 'Smartphone',
    },
    {
      'title': 'Formatação',
      'description': 'Formatação completa do sistema',
      'price': 'R\$ 80,00',
      'duration': '1-2 horas',
      'icon': Icons.laptop,
      'category': 'Notebook',
    },
    {
      'title': 'Troca de Bateria',
      'description': 'Substituição de bateria viciada',
      'price': 'R\$ 120,00',
      'duration': '1 hora',
      'icon': Icons.battery_alert,
      'category': 'Smartphone',
    },
    {
      'title': 'Limpeza Interna',
      'description': 'Limpeza completa de componentes',
      'price': 'R\$ 60,00',
      'duration': '1 hora',
      'icon': Icons.cleaning_services,
      'category': 'Desktop',
    },
    {
      'title': 'Recuperação de Dados',
      'description': 'Recuperação de arquivos perdidos',
      'price': 'R\$ 200,00',
      'duration': '2-4 horas',
      'icon': Icons.storage,
      'category': 'Geral',
    },
    {
      'title': 'Instalação de Software',
      'description': 'Instalação e configuração de programas',
      'price': 'R\$ 40,00',
      'duration': '30 min',
      'icon': Icons.download,
      'category': 'Geral',
    },
  ];

  List<Map<String, dynamic>> get _filteredServices {
    List<Map<String, dynamic>> filtered = _allServices;
    
    if (_selectedCategory != 'Todos') {
      filtered = filtered.where((service) => 
        service['category'] == _selectedCategory
      ).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((service) => 
        service['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        service['description'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        service['category'].toLowerCase().contains(_searchQuery.toLowerCase())
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
      backgroundColor: Colors.grey[50],
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
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  Icon(Icons.search, color: Colors.grey),
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
              child: _filteredServices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum serviço encontrado',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
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
                              title: service['title'],
                              description: service['description'],
                              price: service['price'],
                              duration: service['duration'],
                              icon: service['icon'],
                              category: service['category'],
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
                  backgroundColor: Colors.white,
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
  final String title;
  final String description;
  final String price;
  final String duration;
  final IconData icon;
  final String category;

  const _ServiceCard({
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.icon,
    required this.category,
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
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Solicitar Serviço'),
          content: Text('Deseja solicitar o serviço "${widget.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Serviço "${widget.title}" solicitado!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Solicitar'),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
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
                          widget.category,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
                  SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                      SizedBox(width: 4),
                      Text(
                        widget.duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.price,
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