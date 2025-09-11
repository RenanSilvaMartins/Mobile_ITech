class ServiceRequestModel {
  final String id;
  final String technicianName;
  final String service;
  final String urgency;
  final double totalPrice;
  final DateTime date;
  final String time;
  final String address;
  final String description;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  ServiceRequestModel({
    required this.id,
    required this.technicianName,
    required this.service,
    required this.urgency,
    required this.totalPrice,
    required this.date,
    required this.time,
    required this.address,
    required this.description,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'technicianName': technicianName,
      'service': service,
      'urgency': urgency,
      'totalPrice': totalPrice,
      'date': date.toIso8601String(),
      'time': time,
      'address': address,
      'description': description,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}