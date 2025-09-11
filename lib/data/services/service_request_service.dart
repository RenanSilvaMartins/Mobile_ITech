import '../models/service_request_model.dart';

class ServiceRequestService {
  static final List<ServiceRequestModel> _serviceRequests = [
    ServiceRequestModel(
      id: '1',
      technicianName: 'João Silva',
      service: 'Reparo iPhone 12',
      urgency: 'Normal',
      totalPrice: 150.00,
      date: DateTime(2023, 12, 15),
      time: '14:00',
      address: 'São Paulo - SP',
      description: 'Troca de tela e bateria',
      paymentMethod: 'credit_card',
      status: 'Concluído',
      createdAt: DateTime(2023, 12, 15),
    ),
    ServiceRequestModel(
      id: '2',
      technicianName: 'Maria Santos',
      service: 'Formatação Notebook',
      urgency: 'Normal',
      totalPrice: 80.00,
      date: DateTime(2023, 12, 18),
      time: '10:00',
      address: 'São Paulo - SP',
      description: 'Formatação completa do sistema',
      paymentMethod: 'pix',
      status: 'Em andamento',
      createdAt: DateTime(2023, 12, 18),
    ),
    ServiceRequestModel(
      id: '3',
      technicianName: 'Carlos Lima',
      service: 'Reparo Desktop',
      urgency: 'Normal',
      totalPrice: 120.00,
      date: DateTime(2023, 12, 10),
      time: '16:00',
      address: 'São Paulo - SP',
      description: 'Troca de fonte e limpeza',
      paymentMethod: 'cash',
      status: 'Concluído',
      createdAt: DateTime(2023, 12, 10),
    ),
  ];

  static void addServiceRequest(ServiceRequestModel request) {
    _serviceRequests.add(request);
  }

  static List<ServiceRequestModel> getAllServiceRequests() {
    return List.from(_serviceRequests);
  }

  static List<ServiceRequestModel> getServiceRequestsByStatus(String status) {
    return _serviceRequests.where((request) => request.status == status).toList();
  }
}