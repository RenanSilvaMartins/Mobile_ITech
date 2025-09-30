import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TechniciansMapScreen extends StatefulWidget {
  const TechniciansMapScreen({super.key});

  @override
  State<TechniciansMapScreen> createState() => _TechniciansMapScreenState();
}

class _TechniciansMapScreenState extends State<TechniciansMapScreen> {
  final List<Map<String, dynamic>> regions = [
    {
      'name': 'Centro',
      'technicians': 8,
      'color': Colors.green,
      'available': 5,
    },
    {
      'name': 'Zona Sul',
      'technicians': 12,
      'color': Colors.blue,
      'available': 8,
    },
    {
      'name': 'Zona Norte',
      'technicians': 6,
      'color': Colors.orange,
      'available': 3,
    },
    {
      'name': 'Zona Oeste',
      'technicians': 10,
      'color': Colors.purple,
      'available': 7,
    },
    {
      'name': 'Zona Leste',
      'technicians': 9,
      'color': Colors.red,
      'available': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Mapa de Técnicos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Mapa simulado
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Fundo do mapa
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue[100]!,
                          Colors.green[100]!,
                        ],
                      ),
                    ),
                  ),
                  // Marcadores das regiões
                  Positioned(
                    top: 60,
                    left: 80,
                    child: _MapMarker('Centro', Colors.green, 5),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 60,
                    child: _MapMarker('Zona Sul', Colors.blue, 8),
                  ),
                  Positioned(
                    top: 40,
                    right: 70,
                    child: _MapMarker('Zona Norte', Colors.orange, 3),
                  ),
                  Positioned(
                    left: 40,
                    top: 120,
                    child: _MapMarker('Zona Oeste', Colors.purple, 7),
                  ),
                  Positioned(
                    right: 50,
                    bottom: 60,
                    child: _MapMarker('Zona Leste', Colors.red, 4),
                  ),
                  // Indicador de localização atual
                  Positioned(
                    top: 100,
                    left: 120,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.my_location,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Lista de regiões
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Regiões Disponíveis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: regions.length,
                      itemBuilder: (context, index) {
                        final region = regions[index];
                        return _RegionCard(
                          name: region['name'],
                          totalTechnicians: region['technicians'],
                          availableTechnicians: region['available'],
                          color: region['color'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Localizando técnicos próximos...'),
              backgroundColor: AppColors.primaryPurple,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: AppColors.primaryPurple,
        child: Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  final String region;
  final Color color;
  final int availableCount;

  const _MapMarker(this.region, this.color, this.availableCount);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(region),
            content: Text('$availableCount técnicos disponíveis nesta região'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: Colors.white, size: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$availableCount',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionCard extends StatelessWidget {
  final String name;
  final int totalTechnicians;
  final int availableTechnicians;
  final Color color;

  const _RegionCard({
    required this.name,
    required this.totalTechnicians,
    required this.availableTechnicians,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
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
          Container(
            width: 12,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '$availableTechnicians de $totalTechnicians técnicos disponíveis',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$availableTechnicians',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}