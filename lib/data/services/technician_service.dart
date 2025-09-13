import 'dart:math';
import '../models/technician_model.dart';

class TechnicianService {
  static final TechnicianService _instance = TechnicianService._internal();
  factory TechnicianService() => _instance;
  TechnicianService._internal();

  TechnicianModel? _currentTechnician;

  TechnicianModel? get currentTechnician => _currentTechnician;

  void setCurrentTechnician(TechnicianModel technician) {
    _currentTechnician = technician;
  }

  void logout() {
    _currentTechnician = null;
  }

  // Simula login do técnico
  TechnicianModel? loginTechnician(String email, String password) {
    final technician = TechnicianModel(
      id: '1',
      name: 'Carlos Técnico',
      specialty: 'Especialista em Hardware',
      rating: 4.8,
      experience: '5 anos',
      available: true,
      image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      phone: '(11) 99999-0000',
      email: email,
      services: ['Reparo de Hardware', 'Formatação', 'Instalação de Software'],
      latitude: -23.5505,
      longitude: -46.6333,
      address: 'São Paulo, SP',
      reviews: [],
      completedServices: 127,
    );
    
    setCurrentTechnician(technician);
    return technician;
  }

  static final List<TechnicianModel> _technicians = [
    TechnicianModel(
      id: '1',
      name: 'João Silva',
      specialty: 'Smartphones e Tablets',
      rating: 4.8,
      experience: '5 anos',
      available: true,
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      phone: '(11) 99999-1111',
      email: 'joao.silva@email.com',
      services: ['Reparo de Tela', 'Troca de Bateria', 'Formatação'],
      latitude: -23.5505,
      longitude: -46.6333,
      address: 'Centro, São Paulo - SP',
      completedServices: 240,
      reviews: [
        ReviewModel(
          id: '1',
          clientName: 'Pedro Lima',
          rating: 5.0,
          comment: 'Excelente profissional! Resolveu meu problema rapidamente.',
          date: '15/12/2023',
          service: 'Reparo de tela',
        ),
        ReviewModel(
          id: '2',
          clientName: 'Ana Costa',
          rating: 4.5,
          comment: 'Muito atencioso e competente.',
          date: '10/12/2023',
          service: 'Troca de bateria',
        ),
      ],
    ),
    TechnicianModel(
      id: '2',
      name: 'Maria Santos',
      specialty: 'Notebooks e Desktops',
      rating: 4.9,
      experience: '7 anos',
      available: true,
      image: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      phone: '(11) 99999-2222',
      email: 'maria.santos@email.com',
      services: ['Formatação', 'Limpeza Interna', 'Recuperação de Dados'],
      latitude: -23.5629,
      longitude: -46.6544,
      address: 'Vila Madalena, São Paulo - SP',
      completedServices: 345,
      reviews: [
        ReviewModel(
          id: '3',
          clientName: 'Carlos Oliveira',
          rating: 5.0,
          comment: 'Trabalho impecável, preço justo.',
          date: '08/12/2023',
          service: 'Formatação',
        ),
      ],
    ),
    TechnicianModel(
      id: '3',
      name: 'Carlos Oliveira',
      specialty: 'Eletrônicos em Geral',
      rating: 4.7,
      experience: '3 anos',
      available: false,
      image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      phone: '(11) 99999-3333',
      email: 'carlos.oliveira@email.com',
      services: ['Reparo de Tela', 'Instalação de Software', 'Limpeza Interna'],
      latitude: -23.5733,
      longitude: -46.6417,
      address: 'Pinheiros, São Paulo - SP',
      completedServices: 156,
      reviews: [],
    ),
    TechnicianModel(
      id: '4',
      name: 'Ana Costa',
      specialty: 'Smartphones',
      rating: 4.9,
      experience: '4 anos',
      available: true,
      image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      phone: '(11) 99999-4444',
      email: 'ana.costa@email.com',
      services: ['Reparo de Tela', 'Troca de Bateria'],
      latitude: -23.5489,
      longitude: -46.6388,
      address: 'República, São Paulo - SP',
      completedServices: 198,
      reviews: [
        ReviewModel(
          id: '4',
          clientName: 'Julia Mendes',
          rating: 4.5,
          comment: 'Muito atenciosa e competente. Recomendo!',
          date: '12/12/2023',
          service: 'Troca de bateria',
        ),
      ],
    ),
  ];

  List<TechnicianModel> getAllTechnicians() {
    return _technicians;
  }

  List<TechnicianModel> getAvailableTechnicians() {
    return _technicians.where((tech) => tech.available).toList();
  }

  TechnicianModel? getTechnicianById(String id) {
    try {
      return _technicians.firstWhere((tech) => tech.id == id);
    } catch (e) {
      return null;
    }
  }

  List<TechnicianModel> searchTechnicians(String query) {
    return _technicians.where((tech) =>
      tech.name.toLowerCase().contains(query.toLowerCase()) ||
      tech.specialty.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<TechnicianModel> filterBySpecialty(String specialty) {
    return _technicians.where((tech) =>
      tech.specialty.toLowerCase().contains(specialty.toLowerCase())
    ).toList();
  }

  List<TechnicianModel> getTechniciansByLocation(double lat, double lng, double radiusKm) {
    return _technicians.where((tech) {
      double distance = _calculateDistance(lat, lng, tech.latitude, tech.longitude);
      return distance <= radiusKm;
    }).toList();
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Fórmula de Haversine simplificada para cálculo de distância
    const double earthRadius = 6371; // Raio da Terra em km
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLng = _degreesToRadians(lng2 - lng1);
    
    double a = (dLat / 2) * (dLat / 2) +
        _degreesToRadians(lat1) * _degreesToRadians(lat2) *
        (dLng / 2) * (dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void registerTechnician({
    required String name,
    required String email,
    required String phone,
    required String specialty,
  }) {
    final newTechnician = TechnicianModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      specialty: specialty,
      rating: 0.0,
      experience: 'Novo técnico',
      available: true,
      image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      phone: phone,
      email: email,
      services: [],
      latitude: -23.5505,
      longitude: -46.6333,
      address: 'São Paulo - SP',
      completedServices: 0,
      reviews: [],
    );
    _technicians.add(newTechnician);
  }
}