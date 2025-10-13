import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'technician_home_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/social_login_button.dart';
import '../widgets/logo_widgets.dart';
import '../../data/models/user_model.dart';
import '../../data/services/user_service.dart';
import '../../data/services/technician_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showValidation = false;
  bool _obscurePassword = true;
  bool _isTechnician = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('saved_email') ?? '';
      _passwordController.text = prefs.getString('saved_password') ?? '';
      _rememberMe = prefs.getBool('remember_me') ?? false;
    });
  }

  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', _emailController.text);
      await prefs.setString('saved_password', _passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                          Icons.lock_outline,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        AppStrings.loginTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        AppStrings.loginSubtitle,
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
              // Content Section
              Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(height: 32),
                    // Login Form Card
                    Container(
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColorDark,
                            blurRadius: 24,
                            offset: Offset(0, 12),
                            spreadRadius: 0,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Toggle para escolher tipo de login
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.divider),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowColor,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
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
                                    _isTechnician ? 'Login como Técnico' : 'Login como Cliente',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.textPrimary,
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
                                  activeThumbColor: AppColors.primaryPurple,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          ValidatedTextField(
                            hintText: _emailController.text.isEmpty ? 'usuario@exemplo.com' : AppStrings.emailHint,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            isValid: _isValidEmail(_emailController.text),
                            showValidation: _showValidation,
                            prefixIcon: Icons.email_outlined,
                          ),
                          SizedBox(height: 20),
                          ValidatedTextField(
                            hintText: AppStrings.passwordHint,
                            obscureText: _obscurePassword,
                            controller: _passwordController,
                            isValid: _isValidPassword(_passwordController.text),
                            showValidation: _showValidation,
                            isLast: true,
                            isPassword: true,
                            prefixIcon: Icons.lock_outlined,
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
                                      _emailController.text.isNotEmpty ? Icons.check : Icons.close,
                                      color: _emailController.text.isNotEmpty ? Colors.green : Colors.red,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Email não pode ser vazio',
                                      style: TextStyle(
                                        color: _emailController.text.isNotEmpty ? Colors.green : Colors.red,
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
                                        'Email válido',
                                        style: TextStyle(
                                          color: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text) ? Colors.green : Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      _passwordController.text.isNotEmpty ? Icons.check : Icons.close,
                                      color: _passwordController.text.isNotEmpty ? Colors.green : Colors.red,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Senha não pode ser vazia',
                                      style: TextStyle(
                                        color: _passwordController.text.isNotEmpty ? Colors.green : Colors.red,
                                        fontSize: 14,
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
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: AppColors.primaryPurple,
                              ),
                              Text(
                                'Lembrar credenciais',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  AppStrings.forgotPassword,
                                  style: TextStyle(
                                    color: AppColors.primaryPurple,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),
                          CustomButton(
                            text: _isTechnician ? 'Entrar como Técnico' : AppStrings.loginButton,
                            icon: _isTechnician ? Icons.build : Icons.login,
                            onPressed: () async {
                              setState(() {
                                _showValidation = true;
                              });
                              if (_isValidEmail(_emailController.text) && _isValidPassword(_passwordController.text)) {
                                await _saveCredentials();
                                if (_isTechnician) {
                                  // Login como técnico
                                  final technician = TechnicianService().loginTechnician(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                  if (technician != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Login de técnico realizado com sucesso!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => TechnicianHomeScreen()),
                                    );
                                  }
                                } else {
                                  // Login como cliente
                                  UserService().setCurrentUser(UserModel(
                                    id: '1',
                                    name: 'Cliente',
                                    email: _emailController.text,
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeScreen()),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            AppStrings.orContinueWith,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    SizedBox(height: 24),
                    SocialLoginButton(
                      text: AppStrings.continueWithGoogle,
                      logo: GoogleLogo(size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Login com Google'),
                            content: Text('Funcionalidade em desenvolvimento.\n\nPara implementar login real, é necessário:\n• Configurar Firebase\n• Adicionar Google Sign-In\n• Configurar chaves de API'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SocialLoginButton(
                      text: AppStrings.continueWithMicrosoft,
                      logo: MicrosoftLogo(size: 24),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Login com Microsoft'),
                            content: Text('Funcionalidade em desenvolvimento.\n\nPara implementar login real, é necessário:\n• Configurar Azure AD\n• Adicionar MSAL\n• Configurar chaves de API'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 32),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}