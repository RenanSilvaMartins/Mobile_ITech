class AgendamentoModel {
  final String? id;
  final String usuarioId;
  final String tecnicoId;
  final String servico;
  final String? servicoId;
  final String? servicoTipo;
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
    this.servicoId,
    this.servicoTipo,
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
      usuarioId: json['usuarioId']?.toString() ?? json['usuario_id']?.toString() ?? '',
      tecnicoId: json['tecnicoId']?.toString() ?? json['tecnico_id']?.toString() ?? '',
      servico: json['servico']?.toString() ?? '',
      servicoId: json['servicoId']?.toString() ?? json['servico_id']?.toString(),
      servicoTipo: json['servicoTipo']?.toString(),
      descricao: json['descricao']?.toString() ?? '',
      endereco: json['endereco']?.toString() ?? '',
      dataAgendamento: DateTime.parse(json['dataAgendamento']?.toString() ?? DateTime.now().toIso8601String()),
      horario: json['horario']?.toString() ?? json['horaAgendamento']?.toString() ?? '',
      urgencia: json['urgencia']?.toString() ?? '',
      preco: double.tryParse(json['preco']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? json['situacao']?.toString() ?? 'Pendente',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'horaAgendamento': horario,
      'dataAgendamento': dataAgendamento.toIso8601String().split('T')[0],
      'tecnicoId': int.parse(tecnicoId),
      'servicoId': servicoId != null ? int.parse(servicoId!) : 1,
      'clienteId': 1, // ID fixo do cliente
      'usuarioId': int.parse(usuarioId),
      'descricao': descricao,
      'urgencia': urgencia.toLowerCase(),
      'situacao': 'ATIVO',
      'preco': preco,
    };
  }
}