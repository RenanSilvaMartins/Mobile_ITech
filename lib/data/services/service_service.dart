import '../models/service_model.dart';
import '../models/technician_model.dart';
import 'technician_service.dart';

class ServiceService {
  static final ServiceService _instance = ServiceService._internal();
  factory ServiceService() => _instance;
  ServiceService._internal();

  static final List<ServiceModel> _services = [
    ServiceModel(
      id: 1,
      nome: 'Reparo de Tela',
      preco: 150.00,
      duracao: '2-3 horas',
      tipo: 'Smartphone',
      description: 'Troca de tela quebrada ou com defeito',
      requiredSpecialty: 'Smartphones',
    ),
    ServiceModel(
      id: 2,
      nome: 'Formatação',
      preco: 80.00,
      duracao: '1-2 horas',
      tipo: 'Notebook',
      description: 'Formatação completa do sistema',
      requiredSpecialty: 'Notebooks',
    ),
    ServiceModel(
      id: 3,
      nome: 'Troca de Bateria',
      preco: 120.00,
      duracao: '1 hora',
      tipo: 'Smartphone',
      description: 'Substituição de bateria viciada',
      requiredSpecialty: 'Smartphones',
    ),
    ServiceModel(
      id: 4,
      nome: 'Limpeza Interna',
      preco: 60.00,
      duracao: '1 hora',
      tipo: 'Desktop',
      description: 'Limpeza completa de componentes',
      requiredSpecialty: 'Desktops',
    ),
    ServiceModel(
      id: 5,
      nome: 'Recuperação de Dados',
      preco: 200.00,
      duracao: '2-4 horas',
      tipo: 'Geral',
      description: 'Recuperação de arquivos perdidos',
      requiredSpecialty: 'Notebooks',
    ),
    ServiceModel(
      id: 6,
      nome: 'Instalação de Software',
      preco: 40.00,
      duracao: '30 min',
      tipo: 'Geral',
      description: 'Instalação e configuração de programas',
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
    final service = _services.firstWhere((s) => s.id.toString() == serviceId);
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
      return _services.firstWhere((service) => service.id.toString() == id);
    } catch (e) {
      return null;
    }
  }

  List<ServiceModel> searchServices(String query) {
    return _services.where((service) =>
      service.name.toLowerCase().contains(query.toLowerCase()) ||
      (service.description?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
      service.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}