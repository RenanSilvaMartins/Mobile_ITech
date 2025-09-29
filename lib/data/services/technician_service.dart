import 'dart:math' as math;
import '../models/technician_model.dart';
import '../../controllers/technician_controller.dart';

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
      id: 1,
      cpfCnpj: '12345678901',
      dataNascimento: '1990-01-01',
      telefone: '(11) 99999-0000',
      cep: '01310100',
      numeroResidencia: '123',
      complemento: 'Apto 45',
      descricao: 'Especialista em Hardware com 5 anos de experiência',
      especialidade: 'Hardware',
      usuarioId: 1,
      statusTecnico: 'ativo',
      name: 'Carlos Técnico',
      email: email,
    );
    
    setCurrentTechnician(technician);
    return technician;
  }

  Future<List<TechnicianModel>> getAllTechnicians() async {
    return await TechnicianController.getAllTechnicians();
  }

  Future<List<TechnicianModel>> getAvailableTechnicians() async {
    final technicians = await TechnicianController.getAllTechnicians();
    return technicians.where((tech) => tech.available).toList();
  }

  Future<TechnicianModel?> getTechnicianById(String id) async {
    return await TechnicianController.getTechnicianById(id);
  }

  Future<List<TechnicianModel>> searchTechnicians(String query) async {
    final technicians = await TechnicianController.getAllTechnicians();
    return technicians.where((tech) =>
      tech.name.toLowerCase().contains(query.toLowerCase()) ||
      tech.specialty.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  Future<List<TechnicianModel>> filterBySpecialty(String specialty) async {
    final technicians = await TechnicianController.getAllTechnicians();
    return technicians.where((tech) =>
      tech.specialty.toLowerCase().contains(specialty.toLowerCase())
    ).toList();
  }

  Future<List<TechnicianModel>> getTechniciansByLocation(double lat, double lng, double radiusKm) async {
    final technicians = await TechnicianController.getAllTechnicians();
    return technicians.where((tech) {
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
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  Future<TechnicianModel> registerTechnician({
    required String name,
    required String email,
    required String phone,
    required String specialty,
    required String cpfCnpj,
    required String dataNascimento,
    required String cep,
    required String numeroResidencia,
    String complemento = '',
    String descricao = '',
  }) async {
    final newTechnician = TechnicianModel(
      id: 0, // Será definido pelo banco
      cpfCnpj: cpfCnpj,
      dataNascimento: dataNascimento,
      telefone: phone,
      cep: cep,
      numeroResidencia: numeroResidencia,
      complemento: complemento,
      descricao: descricao.isEmpty ? 'Técnico especializado em $specialty' : descricao,
      especialidade: specialty,
      usuarioId: 0, // Será definido pelo banco
      statusTecnico: 'ativo',
      name: name,
      email: email,
    );
    return await TechnicianController.createTechnician(newTechnician);
  }
}