import 'package:flutter/material.dart';
import '../data/models/service_model.dart';
import 'service_controller.dart';

class ServiceControllerExample extends StatefulWidget {
  const ServiceControllerExample({super.key});

  @override
  _ServiceControllerExampleState createState() => _ServiceControllerExampleState();
}

class _ServiceControllerExampleState extends State<ServiceControllerExample> {
  List<ServiceModel> services = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  // Exemplo: Buscar todos os serviços
  Future<void> _loadServices() async {
    setState(() => isLoading = true);
    try {
      final result = await ServiceController.getAllServices();
      setState(() => services = result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Exemplo: Criar novo serviço
  Future<void> _createService() async {
    final newService = ServiceModel(
      id: 0,
      nome: 'Novo Serviço',
      duracao: '1 hora',
      preco: 50.00,
      tipo: 'Geral',
    );

    try {
      await ServiceController.createService(newService);
      _loadServices(); // Recarrega a lista
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Serviço criado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar serviço: $e')),
      );
    }
  }

  // Exemplo: Deletar serviço
  Future<void> _deleteService(String id) async {
    try {
      await ServiceController.deleteService(id);
      _loadServices(); // Recarrega a lista
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Serviço deletado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar serviço: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Serviços API')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ListTile(
                  title: Text(service.name),
                  subtitle: Text('${service.category} - R\$ ${service.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteService(service.id.toString()),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createService,
        child: Icon(Icons.add),
      ),
    );
  }
}