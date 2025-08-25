import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool isLast;
  final TextEditingController? controller;
  final bool isValid;
  final bool showValidation;
  final bool isPassword;
  final VoidCallback? onToggleVisibility;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isLast = false,
    this.controller,
    this.isValid = true,
    this.showValidation = false,
    this.isPassword = false,
    this.onToggleVisibility,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey[200]!;
    if (widget.showValidation && widget.controller != null) {
      borderColor = widget.isValid ? Colors.green : Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: widget.showValidation && widget.controller != null
              ? borderColor
              : Colors.grey[300]!,
          width: widget.showValidation && widget.controller != null ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
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
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.showValidation && widget.controller != null 
                ? (widget.isValid ? Colors.green[300] : Colors.red[300]) 
                : Colors.grey,
          ),
          border: InputBorder.none,
          suffixIcon: widget.isPassword && widget.onToggleVisibility != null
              ? IconButton(
                  icon: Icon(
                    widget.obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: widget.onToggleVisibility,
                )
              : widget.showValidation && widget.controller != null
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

// Alias para manter compatibilidade com o login
class ValidatedTextField extends CustomTextField {
  const ValidatedTextField({
    super.key,
    required super.hintText,
    required super.controller,
    super.obscureText = false,
    super.keyboardType = TextInputType.text,
    super.isLast = false,
    super.isValid = false,
    super.showValidation = false,
    super.isPassword = false,
    super.onToggleVisibility,
  });
}