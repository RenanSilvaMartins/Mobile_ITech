import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/service_model.dart';
import '../../data/models/technician_model.dart';
import '../../controllers/technician_controller.dart';
import 'technician_detail_screen.dart';
import 'service_request_screen.dart';

class TechniciansScreen extends StatefulWidget {
  final ServiceModel? selectedService;
  
  const TechniciansScreen({super.key, this.selectedService});
  
  @override
  State<TechniciansScreen> createState() => _TechniciansScreenState();
}

class _TechniciansScreenState extends State<TechniciansScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';
  String _searchQuery = '';
  List<TechnicianModel> _allTechnicians = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<TechnicianModel> get _filteredTechnicians {
    List<TechnicianModel> filtered = _allTechnicians;
    
    // Filtra por especialidade do serviço selecionado
    if (widget.selectedService != null) {
      final serviceType = widget.selectedService!.tipo.toLowerCase();
      filtered = filtered.where((tech) => 
        tech.available && tech.especialidade.toLowerCase().contains(serviceType)
      ).toList();
    }
    
    if (_selectedFilter != 'Todos') {
      if (_selectedFilter == 'Disponíveis') {
        filtered = filtered.where((tech) => tech.available == true).toList();
      } else {
        filtered = filtered.where((tech) => 
          tech.specialty.toLowerCase().contains(_selectedFilter.toLowerCase())
        ).toList();
      }
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((tech) => 
        tech.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        tech.specialty.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }
  
  @override
  void initState() {
    super.initState();
    _loadTechnicians();
  }

  Future<void> _loadTechnicians() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      print('Carregando técnicos da API: http://localhost:8082/tecnico');
      final technicians = await TechnicianController.getAllTechnicians();
      print('Técnicos carregados: ${technicians.length}');
      
      if (mounted) {
        setState(() {
          _allTechnicians = technicians;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro detalhado: $e');
      if (mounted) {
        setState(() {
          _allTechnicians = [];
          _errorMessage = 'Falha ao conectar com o servidor. Verifique se a API está rodando em http://localhost:8082/tecnico';
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> _technicianToMap(TechnicianModel tech) {
    return {
      'id': tech.id,
      'name': tech.name,
      'specialty': tech.especialidade,
      'rating': tech.rating,
      'experience': tech.experience,
      'available': tech.available,
      'image': tech.image.isNotEmpty ? tech.image : 'https://via.placeholder.com/150',
      'phone': tech.telefone,
      'description': tech.descricao,
      'address': tech.address,
      'cep': tech.cep,
      'numeroResidencia': tech.numeroResidencia,
      'complemento': tech.complemento,
    };
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
      appBar: AppBar(
        title: Text(
          'Técnicos Disponíveis',
          style: TextStyle(
            color: AppColors.getSurface(isDark),
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
                color: AppColors.getSurface(isDark),
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
                  Icon(Icons.search, color: AppColors.getTextTertiary(isDark)),
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
                ],
              ),
            ),
            SizedBox(height: 16),
            // Technicians List
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
                                'Erro ao carregar técnicos',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.getTextSecondary(isDark),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _loadTechnicians,
                                child: Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        )
                      : _filteredTechnicians.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 64, color: AppColors.getTextTertiary(isDark)),
                                  SizedBox(height: 16),
                                  Text(
                                    'Nenhum técnico encontrado',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.getTextSecondary(isDark),
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
                                    if (widget.selectedService != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ServiceRequestScreen(
                                            technician: _technicianToMap(tech),
                                            selectedService: widget.selectedService,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TechnicianDetailScreen(technician: _technicianToMap(tech)),
                                        ),
                                      );
                                    }
                                  },
                                  child: _TechnicianCard(
                                    technician: tech,
                                    selectedService: widget.selectedService,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
  final TechnicianModel technician;
  final ServiceModel? selectedService;

  const _TechnicianCard({
    required this.technician,
    this.selectedService,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
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
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
                backgroundImage: NetworkImage(technician.image),
                onBackgroundImageError: (exception, stackTrace) {},
                child: Container(),
              ),
              if (technician.available)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.getSurface(isDark), width: 2),
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
                  technician.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(isDark),
                  ),
                ),
                Text(
                  technician.specialty,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.getTextSecondary(isDark),
                  ),
                ),
                Text(
                  'CEP: ${technician.cep}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.getTextTertiary(isDark),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.getTextTertiary(isDark), size: 14),
                    SizedBox(width: 4),
                    Text(
                      technician.region,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.getTextSecondary(isDark),
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
                  color: technician.available ? AppColors.primaryGreen.withOpacity(0.1) : AppColors.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  technician.available ? 'Disponível' : 'Ocupado',
                  style: TextStyle(
                    color: technician.available ? AppColors.primaryGreen : AppColors.primaryRed,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: technician.available ? () {
                  if (selectedService != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceRequestScreen(
                          technician: {
                            'id': technician.id,
                            'name': technician.name,
                            'specialty': technician.specialty,
                            'rating': technician.rating,
                            'experience': technician.experience,
                            'available': technician.available,
                            'image': technician.image,
                            'address': technician.address,
                            'cep': technician.cep,
                            'numeroResidencia': technician.numeroResidencia,
                            'complemento': technician.complemento,
                          },
                          selectedService: selectedService,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Solicitação enviada para ${technician.name}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
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
                  selectedService != null ? 'Escolher' : 'Solicitar',
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