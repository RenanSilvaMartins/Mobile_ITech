import 'package:flutter/material.dart';
import '../data/models/technician_model.dart';
import 'technician_controller.dart';

class TechnicianControllerExample extends StatefulWidget {
  const TechnicianControllerExample({super.key});

  @override
  _TechnicianControllerExampleState createState() => _TechnicianControllerExampleState();
}

class _TechnicianControllerExampleState extends State<TechnicianControllerExample> {
  List<TechnicianModel> technicians = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTechnicians();
  }

  // Exemplo: Buscar todos os técnicos
  Future<void> _loadTechnicians() async {
    setState(() => isLoading = true);
    try {
      final result = await TechnicianController.getAllTechnicians();
      setState(() => technicians = result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Exemplo: Criar novo técnico
  Future<void> _createTechnician() async {
    final newTechnician = TechnicianModel(
      id: 0,
      cpfCnpj: '123.456.789-00',
      dataNascimento: '1990-01-01',
      telefone: '(11) 99999-9999',
      cep: '01234-567',
      numeroResidencia: '123',
      complemento: 'Apto 45',
      descricao: 'Técnico especializado em hardware',
      especialidade: 'Hardware',
      usuarioId: 1,
      statusTecnico: 'Ativo',
      name: 'Novo Técnico',
      email: 'novo@email.com',
      image: '',
    );

    try {
      await TechnicianController.createTechnician(newTechnician);
      _loadTechnicians(); // Recarrega a lista
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Técnico criado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar técnico: $e')),
      );
    }
  }

  // Exemplo: Deletar técnico
  Future<void> _deleteTechnician(String id) async {
    try {
      await TechnicianController.deleteTechnician(id);
      _loadTechnicians(); // Recarrega a lista
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Técnico deletado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar técnico: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Técnicos API')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: technicians.length,
              itemBuilder: (context, index) {
                final tech = technicians[index];
                return ListTile(
                  title: Text(tech.name),
                  subtitle: Text(tech.specialty),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTechnician(tech.id.toString()),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTechnician,
        child: Icon(Icons.add),
      ),
    );
  }
}