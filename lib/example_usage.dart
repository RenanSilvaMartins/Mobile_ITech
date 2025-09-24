// Exemplo de uso da associação entre técnicos e serviços

import 'data/services/service_service.dart';
import 'data/services/technician_service.dart';

void demonstrateServiceTechnicianAssociation() {
  final serviceService = ServiceService();
  final technicianService = TechnicianService();

  print('=== DEMONSTRAÇÃO: ASSOCIAÇÃO TÉCNICOS x SERVIÇOS ===\n');

  // Listar todos os serviços
  final allServices = serviceService.getAllServices();
  print('TODOS OS SERVIÇOS:');
  for (var service in allServices) {
    print('- ${service.name} (${service.category}) - Especialidade: ${service.requiredSpecialty}');
  }

  print('\n=== TÉCNICOS POR SERVIÇO ===\n');

  // Para cada serviço, mostrar quais técnicos podem realizá-lo
  for (var service in allServices) {
    final qualifiedTechnicians = serviceService.getTechniciansForService(service.id);
    
    print('SERVIÇO: ${service.name}');
    print('Especialidade necessária: ${service.requiredSpecialty}');
    print('Técnicos qualificados:');
    
    if (qualifiedTechnicians.isEmpty) {
      print('  - Nenhum técnico disponível');
    } else {
      for (var tech in qualifiedTechnicians) {
        print('  - ${tech.name} (${tech.specialty}) - Rating: ${tech.rating}');
      }
    }
    print('');
  }

  print('=== SERVIÇOS POR ESPECIALIDADE ===\n');

  // Mostrar serviços por especialidade
  final specialties = ['Smartphones', 'Notebooks', 'Desktops', 'Geral'];
  
  for (var specialty in specialties) {
    final servicesForSpecialty = serviceService.getServicesBySpecialty(specialty);
    final techniciansForSpecialty = technicianService.filterBySpecialty(specialty);
    
    print('ESPECIALIDADE: $specialty');
    print('Serviços disponíveis:');
    for (var service in servicesForSpecialty) {
      print('  - ${service.name}');
    }
    
    print('Técnicos especializados:');
    for (var tech in techniciansForSpecialty) {
      print('  - ${tech.name} (${tech.experience})');
    }
    print('');
  }
}