class ServiceModel {
  final int id;
  final String nome;
  final String duracao;
  final double preco;
  final String tipo;
  
  // Campos para compatibilidade com a UI
  final String? description;
  final String? requiredSpecialty;

  ServiceModel({
    required this.id,
    required this.nome,
    required this.duracao,
    required this.preco,
    required this.tipo,
    this.description,
    this.requiredSpecialty,
  });

  // Getters para compatibilidade com a UI existente
  String get name => nome;
  double get price => preco;
  String get duration => duracao;
  String get category => tipo;

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: _parseInt(json['id']),
      nome: json['nome']?.toString() ?? '',
      duracao: json['duracao']?.toString() ?? '',
      preco: _parseDouble(json['preco']),
      tipo: json['tipo']?.toString() ?? '',
      description: json['description']?.toString(),
      requiredSpecialty: json['requiredSpecialty']?.toString() ?? json['tipo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != 0) 'id': id,
      'nome': nome,
      'duracao': duracao,
      'preco': preco,
      'tipo': tipo,
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
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