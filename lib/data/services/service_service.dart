import '../models/service_model.dart';
import '../models/technician_model.dart';
import 'technician_service.dart';

class ServiceService {
  static final ServiceService _instance = ServiceService._internal();
  factory ServiceService() => _instance;
  ServiceService._internal();

  static final List<ServiceModel> _services = [
    ServiceModel(
      id: '1',
      name: 'Reparo de Tela',
      price: 150.00,
      duration: '2-3 horas',
      description: 'Troca de tela quebrada ou com defeito',
      category: 'Smartphone',
      requiredSpecialty: 'Smartphones',
    ),
    ServiceModel(
      id: '2',
      name: 'Formatação',
      price: 80.00,
      duration: '1-2 horas',
      description: 'Formatação completa do sistema',
      category: 'Notebook',
      requiredSpecialty: 'Notebooks',
    ),
    ServiceModel(
      id: '3',
      name: 'Troca de Bateria',
      price: 120.00,
      duration: '1 hora',
      description: 'Substituição de bateria viciada',
      category: 'Smartphone',
      requiredSpecialty: 'Smartphones',
    ),
    ServiceModel(
      id: '4',
      name: 'Limpeza Interna',
      price: 60.00,
      duration: '1 hora',
      description: 'Limpeza completa de componentes',
      category: 'Desktop',
      requiredSpecialty: 'Desktops',
    ),
    ServiceModel(
      id: '5',
      name: 'Recuperação de Dados',
      price: 200.00,
      duration: '2-4 horas',
      description: 'Recuperação de arquivos perdidos',
      category: 'Geral',
      requiredSpecialty: 'Notebooks',
    ),
    ServiceModel(
      id: '6',
      name: 'Instalação de Software',
      price: 40.00,
      duration: '30 min',
      description: 'Instalação e configuração de programas',
      category: 'Geral',
      requiredSpecialty: 'Geral',
    ),
  ];

  List<ServiceModel> getAllServices() {
    return _services;
  }

  List<ServiceModel> getServicesByCategory(String category) {
    return _services.where((service) => service.category == category).toList();
  }

  List<ServiceModel> getServicesBySpecialty(String specialty) {
    return _services.where((service) => 
      service.requiredSpecialty.toLowerCase().contains(specialty.toLowerCase()) ||
      service.requiredSpecialty == 'Geral'
    ).toList();
  }

  Future<List<TechnicianModel>> getTechniciansForService(String serviceId) async {
    final service = _services.firstWhere((s) => s.id == serviceId);
    final technicianService = TechnicianService();
    
    final technicians = await technicianService.getAvailableTechnicians();
    return technicians.where((technician) {
      // Verifica se o técnico tem a especialidade necessária
      return technician.specialty.toLowerCase().contains(service.requiredSpecialty.toLowerCase()) ||
             service.requiredSpecialty == 'Geral';
    }).toList();
  }

  ServiceModel? getServiceById(String id) {
    try {
      return _services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ServiceModel> searchServices(String query) {
    return _services.where((service) =>
      service.name.toLowerCase().contains(query.toLowerCase()) ||
      service.description.toLowerCase().contains(query.toLowerCase()) ||
      service.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}