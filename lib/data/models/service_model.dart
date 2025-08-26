class ServiceModel {
  final String id;
  final String name;
  final double price;
  final String duration;
  final String description;
  final String category;

  ServiceModel({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.description,
    required this.category,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      duration: json['duration'],
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration': duration,
      'description': description,
      'category': category,
    };
  }
}

class ServiceRequestModel {
  final String id;
  final String technicianId;
  final String clientId;
  final String serviceId;
  final String urgency;
  final DateTime date;
  final String time;
  final String address;
  final String description;
  final double totalPrice;
  final String status;
  final String? paymentId;

  ServiceRequestModel({
    required this.id,
    required this.technicianId,
    required this.clientId,
    required this.serviceId,
    required this.urgency,
    required this.date,
    required this.time,
    required this.address,
    required this.description,
    required this.totalPrice,
    required this.status,
    this.paymentId,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: json['id'],
      technicianId: json['technicianId'],
      clientId: json['clientId'],
      serviceId: json['serviceId'],
      urgency: json['urgency'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      address: json['address'],
      description: json['description'],
      totalPrice: json['totalPrice'].toDouble(),
      status: json['status'],
      paymentId: json['paymentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'technicianId': technicianId,
      'clientId': clientId,
      'serviceId': serviceId,
      'urgency': urgency,
      'date': date.toIso8601String(),
      'time': time,
      'address': address,
      'description': description,
      'totalPrice': totalPrice,
      'status': status,
      'paymentId': paymentId,
    };
  }
}