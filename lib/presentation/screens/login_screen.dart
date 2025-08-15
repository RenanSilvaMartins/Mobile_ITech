import 'package:flutter/material.dart';
import 'cadastro_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/social_login_button.dart';
import '../widgets/logo_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showValidation = false;
  bool _obscurePassword = true;

  bool _isValidEmail(String email) {
    return email.isNotEmpty && email.endsWith('@gmail.com') && email.length > 10;
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.loginGradient,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.loginTitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      AppStrings.loginSubtitle,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                      children: <Widget>[
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.noAccount,
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CadastroScreen()),
                                );
                              },
                              child: Text(
                                AppStrings.signUp,
                                style: TextStyle(
                                  color: Colors.purple[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Column(children: <Widget>[
                          ValidatedTextField(
                            hintText: _emailController.text.isEmpty ? 'usuario@gmail.com' : AppStrings.emailHint,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            isValid: _isValidEmail(_emailController.text),
                            showValidation: _showValidation,
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
                            onToggleVisibility: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ]),
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
                                    _emailController.text.endsWith('@gmail.com') && _emailController.text.contains('@') && _emailController.text.indexOf('@') > 0 ? Icons.check : Icons.close,
                                    color: _emailController.text.endsWith('@gmail.com') && _emailController.text.contains('@') && _emailController.text.indexOf('@') > 0 ? Colors.green : Colors.red,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Sintaxe de email válida (ex: usuario@gmail.com)',
                                      style: TextStyle(
                                        color: _emailController.text.endsWith('@gmail.com') && _emailController.text.contains('@') && _emailController.text.indexOf('@') > 0 ? Colors.green : Colors.red,
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
                        SizedBox(height: 40),
                        Text(AppStrings.forgotPassword,
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 40),
                        CustomButton(
                          text: AppStrings.loginButton,
                          onPressed: () {
                            setState(() {
                              _showValidation = true;
                            });
                            if (_isValidEmail(_emailController.text) && _isValidPassword(_passwordController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Login realizado com sucesso!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                AppStrings.orContinueWith,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),
                        SizedBox(height: 20),
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
                      ],
                    ),
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

class ValidatedTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool isLast;
  final TextEditingController controller;
  final bool isValid;
  final bool showValidation;
  final bool isPassword;
  final VoidCallback? onToggleVisibility;

  const ValidatedTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isLast = false,
    this.isValid = false,
    this.showValidation = false,
    this.isPassword = false,
    this.onToggleVisibility,
  });

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey[200]!;
    if (widget.showValidation) {
      borderColor = widget.isValid ? Colors.green : Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: widget.showValidation ? 2 : 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        onChanged: (value) {
          if (widget.showValidation) {
            setState(() {});
          }
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.showValidation ? (widget.isValid ? Colors.green[300] : Colors.red[300]) : Colors.grey,
          ),
          border: InputBorder.none,
          suffixIcon: widget.isPassword
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.showValidation)
                      Icon(
                        widget.isValid ? Icons.check_circle : Icons.error,
                        color: widget.isValid ? Colors.green : Colors.red,
                      ),
                    IconButton(
                      icon: Icon(
                        widget.obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: widget.onToggleVisibility,
                    ),
                  ],
                )
              : widget.showValidation
                  ? Icon(
                      widget.isValid ? Icons.check_circle : Icons.error,
                      color: widget.isValid ? Colors.green : Colors.red,
                    )
                  : null,
        ),
      ),
    );
  }
}