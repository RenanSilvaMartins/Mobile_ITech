class AgendamentoModel {
  final String? id;
  final String usuarioId;
  final String tecnicoId;
  final String servico;
  final String descricao;
  final String endereco;
  final DateTime dataAgendamento;
  final String horario;
  final String urgencia;
  final double preco;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AgendamentoModel({
    this.id,
    required this.usuarioId,
    required this.tecnicoId,
    required this.servico,
    required this.descricao,
    required this.endereco,
    required this.dataAgendamento,
    required this.horario,
    required this.urgencia,
    required this.preco,
    this.status = 'Pendente',
    this.createdAt,
    this.updatedAt,
  });

  factory AgendamentoModel.fromJson(Map<String, dynamic> json) {
    return AgendamentoModel(
      id: json['id']?.toString(),
      usuarioId: json['usuarioId']?.toString() ?? '',
      tecnicoId: json['tecnicoId']?.toString() ?? '',
      servico: json['servico'] ?? '',
      descricao: json['descricao'] ?? '',
      endereco: json['endereco'] ?? '',
      dataAgendamento: DateTime.parse(json['dataAgendamento']),
      horario: json['horario'] ?? '',
      urgencia: json['urgencia'] ?? '',
      preco: (json['preco'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pendente',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioId': int.parse(usuarioId),
      'tecnicoId': int.parse(tecnicoId),
      'servico': servico,
      'descricao': descricao,
      'endereco': endereco,
      'dataAgendamento': dataAgendamento.toIso8601String().split('T')[0],
      'horario': horario,
      'urgencia': urgencia,
      'preco': preco,
      'status': status,
    };
  }
}