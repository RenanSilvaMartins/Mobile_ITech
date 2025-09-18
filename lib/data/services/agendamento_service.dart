import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/agendamento_model.dart';

class AgendamentoService {
  static const String baseUrl = 'http://localhost:8082'; // Substitua pela URL real da API

  // GET /agendamento - Listar todos
  static Future<List<AgendamentoModel>> listarTodos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/agendamento'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AgendamentoModel.fromJson(json)).toList();
      }
      throw Exception('Erro ao carregar agendamentos');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // GET /agendamento/{id} - Buscar por ID
  static Future<AgendamentoModel> buscarPorId(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/agendamento/$id'));
      if (response.statusCode == 200) {
        return AgendamentoModel.fromJson(json.decode(response.body));
      }
      throw Exception('Agendamento não encontrado');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // POST /agendamento - Criar agendamento
  static Future<AgendamentoModel> criar(AgendamentoModel agendamento) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/agendamento'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(agendamento.toJson()),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return AgendamentoModel.fromJson(json.decode(response.body));
      }
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // PUT /agendamento/{id} - Atualizar agendamento
  static Future<AgendamentoModel> atualizar(String id, AgendamentoModel agendamento) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/agendamento/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(agendamento.toJson()),
      );
      
      if (response.statusCode == 200) {
        return AgendamentoModel.fromJson(json.decode(response.body));
      }
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // DELETE /agendamento/{id} - Deletar agendamento
  static Future<void> deletar(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/agendamento/$id'));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar agendamento');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // GET /agendamento/usuario/{usuarioId} - Agendamentos por usuário
  static Future<List<AgendamentoModel>> buscarPorUsuario(String usuarioId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/agendamento/usuario/$usuarioId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AgendamentoModel.fromJson(json)).toList();
      }
      throw Exception('Erro ao carregar agendamentos do usuário');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // GET /agendamento/tecnico/{tecnicoId} - Agendamentos por técnico
  static Future<List<AgendamentoModel>> buscarPorTecnico(String tecnicoId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/agendamento/tecnico/$tecnicoId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AgendamentoModel.fromJson(json)).toList();
      }
      throw Exception('Erro ao carregar agendamentos do técnico');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // GET /agendamento/data/{dataAgendamento} - Agendamentos por data
  static Future<List<AgendamentoModel>> buscarPorData(DateTime data) async {
    try {
      final dataFormatada = data.toIso8601String().split('T')[0];
      final response = await http.get(Uri.parse('$baseUrl/agendamento/data/$dataFormatada'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((json) => AgendamentoModel.fromJson(json)).toList();
      }
      throw Exception('Erro ao carregar agendamentos da data');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}