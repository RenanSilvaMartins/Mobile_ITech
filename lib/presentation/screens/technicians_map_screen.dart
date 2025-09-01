import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/technician_model.dart';
import '../../data/services/technician_service.dart';
import 'technician_detail_screen.dart';

class TechniciansMapScreen extends StatefulWidget {
  const TechniciansMapScreen({Key? key}) : super(key: key);

  @override
  State<TechniciansMapScreen> createState() => _TechniciansMapScreenState();
}

class _TechniciansMapScreenState extends State<TechniciansMapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  List<TechnicianModel> _technicians = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTechnicians();
    _getCurrentLocation();
  }

  void _loadTechnicians() {
    _technicians = TechnicianService.getAvailableTechnicians();
    _createMarkers();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = position;
          _isLoading = false;
        });
        
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createMarkers() {
    _markers.clear();
    
    // Adicionar marcador da localização atual
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Sua Localização'),
        ),
      );
    }

    // Adicionar marcadores dos técnicos
    for (TechnicianModel technician in _technicians) {
      _markers.add(
        Marker(
          markerId: MarkerId(technician.id),
          position: LatLng(technician.latitude, technician.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: technician.name,
            snippet: '${technician.specialty} - ⭐ ${technician.rating}',
            onTap: () => _showTechnicianBottomSheet(technician),
          ),
        ),
      );
    }
    
    setState(() {});
  }

  void _showTechnicianBottomSheet(TechnicianModel technician) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(technician.image),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          technician.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          technician.specialty,
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
                              technician.rating.toString(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.work, color: Colors.grey, size: 16),
                            SizedBox(width: 4),
                            Text(technician.experience),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.primaryPurple),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      technician.address,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.phone, color: AppColors.primaryPurple),
                  SizedBox(width: 8),
                  Text(
                    technician.phone,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TechnicianDetailScreen(
                              technician: technician.toJson(),
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Ver Detalhes',
                        style: TextStyle(color: AppColors.primaryPurple),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navegar para solicitação de serviço
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Solicitar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Técnicos Próximos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryPurple,
              ),
            )
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                if (_currentPosition != null) {
                  controller.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    ),
                  );
                }
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition != null
                    ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                    : LatLng(-23.5505, -46.6333), // São Paulo como padrão
                zoom: 14.0,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "list",
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: Colors.white,
            child: Icon(Icons.list, color: AppColors.primaryPurple),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "location",
            onPressed: _getCurrentLocation,
            backgroundColor: AppColors.primaryPurple,
            child: Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }
}