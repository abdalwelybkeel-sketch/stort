import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CategoryCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String image;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.image,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          final scale = 1.0 + _hoverController.value * 0.05;
          final glowIntensity = 0.3 + _hoverController.value * 0.4;

          return Container(
            width: 120,
            margin: const EdgeInsets.only(left: 16),
            child: Transform.scale(
              scale: scale,
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(glowIntensity),
                          blurRadius: 15 + _hoverController.value * 10,
                          spreadRadius: 2 + _hoverController.value * 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            widget.image,
                            fit: BoxFit.cover,
                          ),
                          // Holographic overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  widget.color.withOpacity(0.6),
                                  widget.color.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                          // Glassmorphism effect
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Icon with glow
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: 32,
                                shadows: [
                                  Shadow(
                                    color: widget.color.withOpacity(0.8),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _isHovered
                          ? widget.color
                          : (isDark ? AppTheme.holographicWhite : AppTheme.metallicGray),
                      shadows: _isHovered
                          ? [
                              Shadow(
                                color: widget.color.withOpacity(0.5),
                                blurRadius: 5,
                              ),
                            ]
                          : null,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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