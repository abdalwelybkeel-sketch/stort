import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class SocialLoginButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _hoverController.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          final scale = 1.0 - _hoverController.value * 0.02;
          
          return Transform.scale(
            scale: scale,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.neonBlue.withOpacity(0.2 + _hoverController.value * 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor == Colors.white
                        ? AppTheme.neonBlue.withOpacity(0.1 + _hoverController.value * 0.2)
                        : Colors.black.withOpacity(0.2 + _hoverController.value * 0.3),
                    blurRadius: 10 + _hoverController.value * 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.textColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 24,
                      color: widget.textColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}