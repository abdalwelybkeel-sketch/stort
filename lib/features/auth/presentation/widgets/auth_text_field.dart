import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  bool _isFocused = false;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppTheme.neonBlue.withOpacity(0.3 + _glowController.value * 0.2),
                      blurRadius: 15 + _glowController.value * 10,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppTheme.neonBlue.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            validator: widget.validator,
            onTap: () => setState(() => _isFocused = true),
            onTapOutside: (_) => setState(() => _isFocused = false),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? AppTheme.holographicWhite : AppTheme.metallicGray,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(
                color: _isFocused
                    ? AppTheme.neonBlue
                    : (isDark ? AppTheme.holographicWhite : AppTheme.metallicGray)
                        .withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: isDark
                  ? AppTheme.metallicGray.withOpacity(0.3)
                  : Colors.white.withOpacity(0.8),
              prefixIcon: widget.prefixIcon != null 
                  ? Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: _isFocused
                            ? LinearGradient(
                                colors: [AppTheme.neonBlue, AppTheme.neonPurple],
                              )
                            : null,
                        color: _isFocused
                            ? null
                            : AppTheme.neonBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.prefixIcon,
                        color: _isFocused
                            ? Colors.white
                            : AppTheme.neonBlue,
                        size: 20,
                      ),
                    )
                  : null,
              suffixIcon: widget.isPassword
                  ? Container(
                      margin: const EdgeInsets.all(12),
                      child: IconButton(
                        icon: Icon(
                          _obscureText 
                              ? Icons.visibility_rounded 
                              : Icons.visibility_off_rounded,
                          color: AppTheme.neonBlue,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: AppTheme.neonBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: AppTheme.neonBlue.withOpacity(0.6 + _glowController.value * 0.3),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}