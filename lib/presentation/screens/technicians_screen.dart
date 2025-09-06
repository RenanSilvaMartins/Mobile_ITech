import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'technician_detail_screen.dart';

class TechniciansScreen extends StatefulWidget {
  const TechniciansScreen({Key? key}) : super(key: key);
  
  @override
  State<TechniciansScreen> createState() => _TechniciansScreenState();
}

class _TechniciansScreenState extends State<TechniciansScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _allTechnicians = [
    {
      'name': 'João Silva',
      'specialty': 'Smartphones e Tablets',
      'rating': 4.8,
      'experience': '5 anos',
      'available': true,
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
    },
    {
      'name': 'Maria Santos',
      'specialty': 'Notebooks e Desktops',
      'rating': 4.9,
      'experience': '7 anos',
      'available': true,
      'image': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
    },
    {
      'name': 'Carlos Oliveira',
      'specialty': 'Eletrônicos em Geral',
      'rating': 4.7,
      'experience': '3 anos',
      'available': false,
      'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
    },
    {
      'name': 'Ana Costa',
      'specialty': 'Smartphones',
      'rating': 4.9,
      'experience': '4 anos',
      'available': true,
      'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
    },
  ];

  List<Map<String, dynamic>> get _filteredTechnicians {
    List<Map<String, dynamic>> filtered = _allTechnicians;
    
    if (_selectedFilter != 'Todos') {
      if (_selectedFilter == 'Disponíveis') {
        filtered = filtered.where((tech) => tech['available'] == true).toList();
      } else {
        filtered = filtered.where((tech) => 
          tech['specialty'].toLowerCase().contains(_selectedFilter.toLowerCase())
        ).toList();
      }
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((tech) => 
        tech['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        tech['specialty'].toLowerCase().contains(_searchQuery.toLowerCase())
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
          'Técnicos Disponíveis',
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
                        hintText: 'Buscar técnico...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip('Todos', _selectedFilter == 'Todos', (selected) {
                    setState(() { _selectedFilter = 'Todos'; });
                  }),
                  _FilterChip('Disponíveis', _selectedFilter == 'Disponíveis', (selected) {
                    setState(() { _selectedFilter = 'Disponíveis'; });
                  }),
                  _FilterChip('Smartphones', _selectedFilter == 'Smartphones', (selected) {
                    setState(() { _selectedFilter = 'Smartphones'; });
                  }),
                  _FilterChip('Notebooks', _selectedFilter == 'Notebooks', (selected) {
                    setState(() { _selectedFilter = 'Notebooks'; });
                  }),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Technicians List
            Expanded(
              child: _filteredTechnicians.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum técnico encontrado',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredTechnicians.length,
                      itemBuilder: (context, index) {
                        final tech = _filteredTechnicians[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TechnicianDetailScreen(technician: tech),
                        ),
                      );
                    },
                    child: _TechnicianCard(
                      name: tech['name'],
                      specialty: tech['specialty'],
                      rating: tech['rating'],
                      experience: tech['experience'],
                      available: tech['available'],
                      image: tech['image'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool) onSelected;

  const _FilterChip(this.label, this.selected, this.onSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppColors.primaryPurple.withOpacity(0.2),
        checkmarkColor: AppColors.primaryPurple,
      ),
    );
  }
}

class _TechnicianCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String experience;
  final bool available;
  final String image;

  const _TechnicianCard({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experience,
    required this.available,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
                backgroundImage: NetworkImage(image),
                onBackgroundImageError: (exception, stackTrace) {},
                child: Container(),
              ),
              if (available)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  specialty,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.work, color: Colors.grey, size: 16),
                    SizedBox(width: 4),
                    Text(
                      experience,
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
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: available ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  available ? 'Disponível' : 'Ocupado',
                  style: TextStyle(
                    color: available ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: available ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Solicitação enviada para $name'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Solicitar',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}