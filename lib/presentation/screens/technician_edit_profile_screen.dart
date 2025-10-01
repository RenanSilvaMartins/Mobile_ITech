import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/technician_model.dart';

class TechnicianEditProfileScreen extends StatefulWidget {
  final TechnicianModel? technician;

  const TechnicianEditProfileScreen({super.key, this.technician});

  @override
  State<TechnicianEditProfileScreen> createState() => _TechnicianEditProfileScreenState();
}

class _TechnicianEditProfileScreenState extends State<TechnicianEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _cpfController;
  late TextEditingController _phoneController;
  late TextEditingController _specialtyController;
  late TextEditingController _descriptionController;
  late TextEditingController _cepController;
  late TextEditingController _numberController;
  late TextEditingController _complementController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.technician?.name ?? '');
    _cpfController = TextEditingController(text: widget.technician?.cpfCnpj ?? '');
    _phoneController = TextEditingController(text: widget.technician?.telefone ?? '');
    _specialtyController = TextEditingController(text: widget.technician?.especialidade ?? '');
    _descriptionController = TextEditingController(text: widget.technician?.descricao ?? '');
    _cepController = TextEditingController(text: widget.technician?.cep ?? '');
    _numberController = TextEditingController(text: widget.technician?.numeroResidencia ?? '');
    _complementController = TextEditingController(text: widget.technician?.complemento ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    _descriptionController.dispose();
    _cepController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações Pessoais
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações Pessoais',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nome Completo *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _cpfController,
                        decoration: InputDecoration(
                          labelText: 'CPF/CNPJ *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'CPF/CNPJ é obrigatório';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Telefone *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Telefone é obrigatório';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Especialidade e Descrição
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações Profissionais',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _specialtyController,
                        decoration: InputDecoration(
                          labelText: 'Especialidade *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.build),
                          hintText: 'Ex: Smartphones, Notebooks, Desktops',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Especialidade é obrigatória';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descrição Profissional *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                          hintText: 'Descreva sua experiência e serviços oferecidos',
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Descrição é obrigatória';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Endereço
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Endereço Completo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _cepController,
                        decoration: InputDecoration(
                          labelText: 'CEP *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                          hintText: '00000-000',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'CEP é obrigatório';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _numberController,
                        decoration: InputDecoration(
                          labelText: 'Número *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.home),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Número é obrigatório';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _complementController,
                        decoration: InputDecoration(
                          labelText: 'Complemento',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.apartment),
                          hintText: 'Apto, bloco, etc. (opcional)',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      child: Text('Salvar Alterações'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Aqui você salvaria os dados do perfil
      // Por enquanto, apenas mostra uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}