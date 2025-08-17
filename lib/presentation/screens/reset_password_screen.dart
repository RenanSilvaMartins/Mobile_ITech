import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showValidation = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isValidPassword(String password) {
    if (password.isEmpty || password.length < 8) return false;
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasUpper && hasLower && hasDigit && hasSpecial;
  }

  bool _passwordsMatch() {
    return _passwordController.text == _confirmPasswordController.text;
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
            children: [
              // Header Section
              Container(
                height: 280,
                decoration: BoxDecoration(
                  gradient: AppColors.modernGradient,
                  borderRadius: BorderRadius.circular(32),
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
                          Icons.lock_open_outlined,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Nova Senha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Crie uma nova senha segura',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
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
                    ValidatedTextField(
                      hintText: 'Nova senha',
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      isValid: _isValidPassword(_passwordController.text),
                      showValidation: _showValidation,
                      isPassword: true,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ValidatedTextField(
                      hintText: 'Confirmar nova senha',
                      obscureText: _obscureConfirmPassword,
                      controller: _confirmPasswordController,
                      isValid: _passwordsMatch() && _confirmPasswordController.text.isNotEmpty,
                      showValidation: _showValidation,
                      isPassword: true,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
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
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                _passwordsMatch() && _confirmPasswordController.text.isNotEmpty ? Icons.check : Icons.close,
                                color: _passwordsMatch() && _confirmPasswordController.text.isNotEmpty ? Colors.green : Colors.red,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Senhas coincidem',
                                style: TextStyle(
                                  color: _passwordsMatch() && _confirmPasswordController.text.isNotEmpty ? Colors.green : Colors.red,
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
                      text: 'Redefinir Senha',
                      onPressed: () {
                        setState(() {
                          _showValidation = true;
                        });
                        if (_isValidPassword(_passwordController.text) && _passwordsMatch()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Senha redefinida com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      },
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}