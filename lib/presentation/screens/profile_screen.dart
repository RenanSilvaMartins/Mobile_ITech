import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/user_service.dart';
import 'login_screen.dart';
import 'service_history_screen.dart';
import 'notifications_screen.dart';
import 'help_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _phoneController = TextEditingController(text: '(11) 99999-9999');
  final _addressController = TextEditingController(text: 'Rua das Flores, 123');

  @override
  void initState() {
    super.initState();
    final user = UserService().currentUser;
    _nameController = TextEditingController(text: user?.name ?? 'Cliente');
    _emailController = TextEditingController(text: user?.email ?? 'email@exemplo.com');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with Profile Picture
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.modernGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Meu Perfil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SettingsScreen()),
                            );
                          },
                          icon: Icon(Icons.settings, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Funcionalidade de foto em desenvolvimento'),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      _nameController.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _emailController.text,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Profile Form
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações Pessoais',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    _ProfileField(
                      label: 'Nome Completo',
                      controller: _nameController,
                      icon: Icons.person,
                    ),
                    _ProfileField(
                      label: 'Email',
                      controller: _emailController,
                      icon: Icons.email,
                    ),
                    _ProfileField(
                      label: 'Telefone',
                      controller: _phoneController,
                      icon: Icons.phone,
                    ),
                    _ProfileField(
                      label: 'Endereço',
                      controller: _addressController,
                      icon: Icons.location_on,
                    ),
                    SizedBox(height: 32),
                    // Action Buttons
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Dados atualizados com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Salvar Alterações',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    // Menu Options
                    _MenuOption(
                      icon: Icons.history,
                      title: 'Histórico de Serviços',
                      subtitle: 'Ver todos os serviços solicitados',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ServiceHistoryScreen()),
                        );
                      },
                    ),
                    _MenuOption(
                      icon: Icons.notifications,
                      title: 'Notificações',
                      subtitle: 'Configurar alertas e avisos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotificationsScreen()),
                        );
                      },
                    ),
                    _MenuOption(
                      icon: Icons.help,
                      title: 'Ajuda e Suporte',
                      subtitle: 'Central de ajuda e FAQ',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HelpScreen()),
                        );
                      },
                    ),
                    _MenuOption(
                      icon: Icons.logout,
                      title: 'Sair',
                      subtitle: 'Fazer logout da conta',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirmar Saída'),
                            content: Text('Deseja realmente sair da sua conta?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  UserService().logout();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginScreen()),
                                    (route) => false,
                                  );
                                },
                                child: Text('Sair'),
                              ),
                            ],
                          ),
                        );
                      },
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;

  const _ProfileField({
    required this.label,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryPurple, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLogout;

  const _MenuOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isLogout 
                ? Colors.red.withOpacity(0.1) 
                : AppColors.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon, 
            color: isLogout ? Colors.red : AppColors.primaryPurple,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.red : Colors.grey[800],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}