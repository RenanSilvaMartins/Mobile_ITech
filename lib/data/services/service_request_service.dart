import '../models/service_request_model.dart';

class ServiceRequestService {
  static final List<ServiceRequestModel> _serviceRequests = [];

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