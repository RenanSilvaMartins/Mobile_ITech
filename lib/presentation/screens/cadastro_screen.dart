import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../../data/models/user_model.dart';
import '../../data/services/user_service.dart';
import '../../data/services/technician_service.dart';
import 'home_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _showValidation = false;
  bool _obscurePassword = true;
  bool _isTechnician = false;

  bool _isValidName(String name) {
    return name.trim().length >= 2;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    if (password.isEmpty || password.length < 8) return false;
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasUpper && hasLower && hasDigit && hasSpecial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                height: 280,
                decoration: BoxDecoration(
                  gradient: AppColors.modernGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.person_add_outlined,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        AppStrings.cadastroTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        AppStrings.cadastroSubtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Form Card
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Toggle para escolher tipo de cadastro
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isTechnician ? Icons.build : Icons.person,
                            color: AppColors.primaryPurple,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _isTechnician ? 'Cadastrar como Técnico' : 'Cadastrar como Cliente',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Switch(
                            value: _isTechnician,
                            onChanged: (value) {
                              setState(() {
                                _isTechnician = value;
                              });
                            },
                            thumbColor: WidgetStateProperty.all(AppColors.primaryPurple),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ValidatedTextField(
                      hintText: AppStrings.nameHint,
                      controller: _nameController,
                      isValid: _isValidName(_nameController.text),
                      showValidation: _showValidation,
                    ),
                    SizedBox(height: 20),
                    ValidatedTextField(
                      hintText: AppStrings.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      isValid: _isValidEmail(_emailController.text),
                      showValidation: _showValidation,
                    ),
                    SizedBox(height: 20),
                    if (_isTechnician) ...[
                      ValidatedTextField(
                        hintText: 'Telefone',
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        isValid: _phoneController.text.length >= 10,
                        showValidation: _showValidation,
                      ),
                      SizedBox(height: 20),
                      ValidatedTextField(
                        hintText: 'Especialidade (ex: Celular, Notebook, TV)',
                        controller: _specialtyController,
                        isValid: _specialtyController.text.trim().length >= 3,
                        showValidation: _showValidation,
                      ),
                      SizedBox(height: 20),
                    ],
                    ValidatedTextField(
                      hintText: AppStrings.passwordHint,
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      isValid: _isValidPassword(_passwordController.text),
                      showValidation: _showValidation,
                      isLast: true,
                      isPassword: true,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                      if (_showValidation) ...[
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _nameController.text.trim().length >= 2 ? Icons.check : Icons.close,
                                  color: _nameController.text.trim().length >= 2 ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Nome com pelo menos 2 caracteres',
                                  style: TextStyle(
                                    color: _nameController.text.trim().length >= 2 ? Colors.green : Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text) ? Icons.check : Icons.close,
                                  color: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text) ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Formato de email válido',
                                    style: TextStyle(
                                      color: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text) ? Colors.green : Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _passwordController.text.length >= 8 ? Icons.check : Icons.close,
                                  color: _passwordController.text.length >= 8 ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Mínimo 8 caracteres',
                                  style: TextStyle(
                                    color: _passwordController.text.length >= 8 ? Colors.green : Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _passwordController.text.contains(RegExp(r'[A-Z]')) ? Icons.check : Icons.close,
                                  color: _passwordController.text.contains(RegExp(r'[A-Z]')) ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Letra maiúscula',
                                  style: TextStyle(
                                    color: _passwordController.text.contains(RegExp(r'[A-Z]')) ? Colors.green : Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _passwordController.text.contains(RegExp(r'[a-z]')) ? Icons.check : Icons.close,
                                  color: _passwordController.text.contains(RegExp(r'[a-z]')) ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Letra minúscula',
                                  style: TextStyle(
                                    color: _passwordController.text.contains(RegExp(r'[a-z]')) ? Colors.green : Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _passwordController.text.contains(RegExp(r'[0-9]')) ? Icons.check : Icons.close,
                                  color: _passwordController.text.contains(RegExp(r'[0-9]')) ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Número',
                                  style: TextStyle(
                                    color: _passwordController.text.contains(RegExp(r'[0-9]')) ? Colors.green : Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ? Icons.check : Icons.close,
                                  color: _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Caractere especial',
                                  style: TextStyle(
                                    color: _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ? Colors.green : Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    SizedBox(height: 32),
                    CustomButton(
                      text: _isTechnician ? 'Cadastrar como Técnico' : AppStrings.signUpButton,
                      onPressed: () {
                        setState(() {
                          _showValidation = true;
                        });
                        bool isValidForm = _isValidName(_nameController.text) && 
                            _isValidEmail(_emailController.text) && 
                            _isValidPassword(_passwordController.text);
                        
                        if (_isTechnician) {
                          isValidForm = isValidForm && 
                              _phoneController.text.length >= 10 && 
                              _specialtyController.text.trim().length >= 3;
                        }
                        
                        if (isValidForm) {
                          if (_isTechnician) {
                            // Salvar técnico cadastrado
                            TechnicianService().registerTechnician(
                              name: _nameController.text,
                              email: _emailController.text,
                              phone: _phoneController.text,
                              specialty: _specialtyController.text,
                              cpfCnpj: '00000000000', // Valor padrão temporário
                              dataNascimento: '1990-01-01', // Valor padrão temporário
                              cep: '00000000', // Valor padrão temporário
                              numeroResidencia: '0', // Valor padrão temporário
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Técnico cadastrado com sucesso!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            // Salvar usuário cadastrado
                            UserService().setCurrentUser(UserModel(
                              id: '1',
                              name: _nameController.text,
                              email: _emailController.text,
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Cadastro realizado com sucesso!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                          // Navegar para home após cadastro
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem uma conta? ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppStrings.backToLogin,
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
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
    _passwordController.dispose();
    _specialtyController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}