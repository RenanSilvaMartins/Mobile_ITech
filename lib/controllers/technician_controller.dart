import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/technician_model.dart';

class TechnicianController {
  static const String baseUrl = 'http://localhost:8082/tecnico';
  
  // GET - Buscar todos os técnicos
  static Future<List<TechnicianModel>> getAllTechnicians() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TechnicianModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar técnicos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // GET - Buscar técnico por ID
  static Future<TechnicianModel?> getTechnicianById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode == 200) {
        return TechnicianModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Erro ao buscar técnico: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // POST - Criar novo técnico
  static Future<TechnicianModel> createTechnician(TechnicianModel technician) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(technician.toJson()),
      );
      
      if (response.statusCode == 201) {
        return TechnicianModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro ao criar técnico: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // PUT - Atualizar técnico
  static Future<TechnicianModel> updateTechnician(String id, TechnicianModel technician) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(technician.toJson()),
      );
      
      if (response.statusCode == 200) {
        return TechnicianModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro ao atualizar técnico: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // DELETE - Deletar técnico
  static Future<bool> deleteTechnician(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Erro ao deletar técnico: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}