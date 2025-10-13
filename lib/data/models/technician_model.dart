class TechnicianModel {
  final int id;
  final String cpfCnpj;
  final String dataNascimento;
  final String telefone;
  final String cep;
  final String numeroResidencia;
  final String complemento;
  final String descricao;
  final String especialidade;
  final int usuarioId;
  final String statusTecnico;
  
  // Campos adicionais para compatibilidade com a UI
  final String name;
  final String email;
  final String image;

  TechnicianModel({
    required this.id,
    required this.cpfCnpj,
    required this.dataNascimento,
    required this.telefone,
    required this.cep,
    required this.numeroResidencia,
    required this.complemento,
    required this.descricao,
    required this.especialidade,
    required this.usuarioId,
    required this.statusTecnico,
    required this.name,
    required this.email,
    this.image = '',
  });

  // Getters para compatibilidade com a UI existente
  String get specialty => especialidade;
  String get phone => telefone;
  String get experience => '${DateTime.now().year - DateTime.parse(dataNascimento).year} anos';
  bool get available => statusTecnico.toLowerCase() == 'ativo';
  double get rating => 4.5; // Valor padrão
  String get address => 'CEP: $cep, Nº $numeroResidencia${complemento.isNotEmpty ? ', $complemento' : ''}';
  List<String> get services => [especialidade];
  double get latitude => -23.5505; // Valor padrão São Paulo
  double get longitude => -46.6333; // Valor padrão São Paulo
  List<ReviewModel> get reviews => [];
  int get completedServices => 0;
  
  String get region {
    final cepPrefix = cep.length >= 5 ? cep.substring(0, 5) : cep;
    switch (cepPrefix) {
      case '01000': case '01001': case '01002': case '01003': case '01004': case '01005':
        return 'Centro - SP';
      case '04000': case '04001': case '04002': case '04003': case '04004': case '04005':
        return 'Vila Olímpia - SP';
      case '05000': case '05001': case '05002': case '05003': case '05004': case '05005':
        return 'Lapa - SP';
      case '08000': case '08001': case '08002': case '08003': case '08004': case '08005':
        return 'Itaquera - SP';
      default:
        return 'São Paulo - SP';
    }
  }

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    return TechnicianModel(
      id: _parseInt(json['id']),
      cpfCnpj: json['cpf_cnpj']?.toString() ?? '',
      dataNascimento: json['dataNascimento']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
      cep: json['cep']?.toString() ?? '',
      numeroResidencia: json['numeroResidencia']?.toString() ?? '',
      complemento: json['complemento']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
      especialidade: json['especialidade']?.toString() ?? '',
      usuarioId: _parseInt(json['usuario_id'] ?? json['usuario']?['id']),
      statusTecnico: json['statusTecnico']?.toString() ?? '',
      name: json['name']?.toString() ?? json['usuario']?['nome']?.toString() ?? 'Técnico',
      email: json['email']?.toString() ?? json['usuario']?['email']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != 0) 'id': id,
      'cpf_cnpj': cpfCnpj,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
      'cep': cep,
      'numeroResidencia': numeroResidencia,
      'complemento': complemento,
      'descricao': descricao,
      'especialidade': especialidade,
      'usuario_id': usuarioId,
      'statusTecnico': statusTecnico,
      'name': name,
      'email': email,
      'image': image,
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ReviewModel {
  final String id;
  final String clientName;
  final double rating;
  final String comment;
  final String date;
  final String service;

  ReviewModel({
    required this.id,
    required this.clientName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.service,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? '',
      rating: _parseDouble(json['rating']),
      comment: json['comment']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      service: json['service']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'rating': rating,
      'comment': comment,
      'date': date,
      'service': service,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}