import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/technician_service.dart';
import 'login_screen.dart';

class TechnicianProfileScreen extends StatefulWidget {
  const TechnicianProfileScreen({Key? key}) : super(key: key);

  @override
  State<TechnicianProfileScreen> createState() => _TechnicianProfileScreenState();
}

class _TechnicianProfileScreenState extends State<TechnicianProfileScreen> {
  bool _isAvailable = true;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.modernGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    TechnicianService().currentTechnician?.name ?? 'Técnico',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    TechnicianService().currentTechnician?.specialty ?? 'Especialista',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Avaliação', '${TechnicianService().currentTechnician?.rating.toStringAsFixed(1) ?? '0.0'} ⭐'),
                      _buildStatItem('Serviços', '${TechnicianService().currentTechnician?.completedServices ?? 0}'),
                      _buildStatItem('Experiência', TechnicianService().currentTechnician?.experience ?? '0 anos'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Status Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status de Disponibilidade',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        _isAvailable ? Icons.check_circle : Icons.cancel,
                        color: _isAvailable ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isAvailable ? 'Disponível para novos serviços' : 'Indisponível',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Switch(
                        value: _isAvailable,
                        onChanged: (value) {
                          setState(() {
                            _isAvailable = value;
                          });
                        },
                        activeColor: AppColors.primaryPurple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // Profile Options
          Card(
            child: Column(
              children: [
                _buildProfileOption(
                  Icons.person_outline,
                  'Editar Perfil',
                  'Alterar informações pessoais',
                  () => _showEditProfileDialog(),
                ),
                Divider(height: 1),
                _buildProfileOption(
                  Icons.build_outlined,
                  'Especialidades',
                  'Gerenciar áreas de atuação',
                  () => _showSpecialtiesDialog(),
                ),
                Divider(height: 1),
                _buildProfileOption(
                  Icons.location_on_outlined,
                  'Área de Atendimento',
                  'Definir raio de atendimento',
                  () => _showServiceAreaDialog(),
                ),
                Divider(height: 1),
                _buildProfileOption(
                  Icons.attach_money_outlined,
                  'Preços dos Serviços',
                  'Configurar valores',
                  () => _showPricingDialog(),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Settings
          Card(
            child: Column(
              children: [
                _buildProfileOption(
                  Icons.notifications_outlined,
                  'Notificações',
                  _notificationsEnabled ? 'Ativadas' : 'Desativadas',
                  () {
                    setState(() {
                      _notificationsEnabled = !_notificationsEnabled;
                    });
                  },
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: AppColors.primaryPurple,
                  ),
                ),
                Divider(height: 1),
                _buildProfileOption(
                  Icons.help_outline,
                  'Ajuda e Suporte',
                  'Central de ajuda',
                  () => _showHelpDialog(),
                ),
                Divider(height: 1),
                _buildProfileOption(
                  Icons.info_outline,
                  'Sobre o App',
                  'Versão 1.0.0',
                  () => _showAboutDialog(),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Sair da Conta'),
                    content: Text('Tem certeza que deseja sair?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          TechnicianService().logout();
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: Text('Sair', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout),
              label: Text('Sair da Conta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryPurple),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Perfil atualizado!')),
              );
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showSpecialtiesDialog() {
    final List<String> specialties = [
      'Hardware',
      'Software',
      'Redes',
      'Formatação',
      'Recuperação de Dados',
      'Montagem de PC',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Especialidades'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: specialties.map((specialty) {
              return CheckboxListTile(
                title: Text(specialty),
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primaryPurple,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showServiceAreaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Área de Atendimento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Raio de atendimento: 10 km'),
            SizedBox(height: 16),
            Slider(
              value: 10,
              min: 1,
              max: 50,
              divisions: 49,
              label: '10 km',
              onChanged: (value) {},
              activeColor: AppColors.primaryPurple,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showPricingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Preços dos Serviços'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Formatação',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Reparo de Hardware',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajuda e Suporte'),
        content: Text('Entre em contato conosco:\n\nEmail: suporte@itech.com\nTelefone: (11) 9999-9999'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sobre o App'),
        content: Text('ITech - Plataforma de Serviços Técnicos\n\nVersão: 1.0.0\nDesenvolvido por: Equipe ITech'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }
}