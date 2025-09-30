import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/service_model.dart';

class ServiceController {
  static const String baseUrl = 'http://localhost:8082/servico';
  
  // GET - Buscar todos os serviços
  static Future<List<ServiceModel>> getAllServices() async {
    try {
      print('Fazendo requisição para: $baseUrl');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');
      
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        if (responseData is List) {
          return responseData.map((json) => ServiceModel.fromJson(json)).toList();
        } else {
          throw Exception('Formato de resposta inválido: esperado List, recebido ${responseData.runtimeType}');
        }
      } else {
        throw Exception('Erro HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      rethrow;
    }
  }

  // GET - Buscar serviço por ID
  static Future<ServiceModel?> getServiceById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return ServiceModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Erro HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // POST - Criar novo serviço
  static Future<ServiceModel> createService(ServiceModel service) async {
    try {
      final serviceJson = service.toJson();
      print('Enviando dados: ${json.encode(serviceJson)}');
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(serviceJson),
      );
      
      if (response.statusCode == 201) {
        return ServiceModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro ao criar serviço: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // PUT - Atualizar serviço
  static Future<ServiceModel> updateService(String id, ServiceModel service) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(service.toJson()),
      );
      
      if (response.statusCode == 200) {
        return ServiceModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro ao atualizar serviço: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // DELETE - Deletar serviço
  static Future<bool> deleteService(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Erro ao deletar serviço: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}