import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? label;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool isLast;
  final TextEditingController? controller;
  final bool isValid;
  final bool showValidation;
  final bool isPassword;
  final VoidCallback? onToggleVisibility;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final IconData? prefixIcon;
  final String? errorText;
  final Function(String)? onChanged;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isLast = false,
    this.controller,
    this.isValid = true,
    this.showValidation = false,
    this.isPassword = false,
    this.onToggleVisibility,
    this.inputFormatters,
    this.maxLength,
    this.prefixIcon,
    this.errorText,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _borderColorAnimation;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _borderColorAnimation = ColorTween(
      begin: AppColors.divider,
      end: AppColors.primaryPurple,
    ).animate(_animationController);
    
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Color get _getBorderColor {
    if (widget.showValidation && widget.controller != null) {
      return widget.isValid ? AppColors.primaryGreen : AppColors.primaryRed;
    }
    return _isFocused ? AppColors.primaryPurple : AppColors.divider;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: widget.enabled ? AppColors.surface : AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getBorderColor,
                  width: _isFocused || (widget.showValidation && widget.controller != null) ? 2 : 1,
                ),
                boxShadow: _isFocused ? [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                maxLength: widget.maxLength,
                enabled: widget.enabled,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                onChanged: (value) {
                  if (widget.showValidation) {
                    setState(() {});
                  }
                  widget.onChanged?.call(value);
                },
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  counterText: '',
                  prefixIcon: widget.prefixIcon != null
                      ? Container(
                          margin: const EdgeInsets.only(left: 16, right: 12),
                          child: Icon(
                            widget.prefixIcon,
                            color: _isFocused ? AppColors.primaryPurple : AppColors.textTertiary,
                            size: 20,
                          ),
                        )
                      : null,
                  suffixIcon: _buildSuffixIcon(),
                ),
              ),
            );
          },
        ),
        if (widget.errorText != null && widget.showValidation && !widget.isValid) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                size: 16,
                color: AppColors.primaryRed,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword && widget.onToggleVisibility != null) {
      return Container(
        margin: const EdgeInsets.only(right: 16),
        child: IconButton(
          icon: Icon(
            widget.obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.textTertiary,
            size: 20,
          ),
          onPressed: widget.onToggleVisibility,
        ),
      );
    }
    
    if (widget.showValidation && widget.controller != null && widget.controller!.text.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(right: 20),
        child: Icon(
          widget.isValid ? Icons.check_circle : Icons.cancel,
          color: widget.isValid ? AppColors.primaryGreen : AppColors.primaryRed,
          size: 20,
        ),
      );
    }
    
    return null;
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
    super.prefixIcon,
    super.errorText,
  });
}