import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/theme/app_theme.dart';

class FuturisticBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FuturisticBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FuturisticBottomNav> createState() => _FuturisticBottomNavState();
}

class _FuturisticBottomNavState extends State<FuturisticBottomNav>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late List<AnimationController> _itemControllers;

  final List<NavItem> _items = [
    NavItem(icon: Icons.home_rounded, label: 'الرئيسية'),
    NavItem(icon: Icons.local_florist_rounded, label: 'المنتجات'),
    NavItem(icon: Icons.shopping_cart_rounded, label: 'السلة'),
    NavItem(icon: Icons.receipt_long_rounded, label: 'الطلبات'),
    NavItem(icon: Icons.person_rounded, label: 'الملف'),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _itemControllers = List.generate(
      _items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    // Animate the selected item
    _itemControllers[widget.currentIndex].forward();
  }

  @override
  void didUpdateWidget(FuturisticBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _itemControllers[oldWidget.currentIndex].reverse();
      _itemControllers[widget.currentIndex].forward();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(20),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonBlue.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          AppTheme.metallicGray.withOpacity(0.9),
                          AppTheme.darkSpace.withOpacity(0.9),
                        ]
                      : [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.7),
                        ],
                ),
                border: Border.all(
                  color: AppTheme.neonBlue.withOpacity(
                    0.3 + _glowController.value * 0.2,
                  ),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_items.length, (index) {
                  return _buildNavItem(index, isDark);
                }),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, bool isDark) {
    final isSelected = widget.currentIndex == index;
    final item = _items[index];

    return AnimatedBuilder(
      animation: Listenable.merge([
        _itemControllers[index],
        _pulseController,
        _glowController,
      ]),
      builder: (context, child) {
        final scale = 1.0 + _itemControllers[index].value * 0.2;
        final glowIntensity = isSelected
            ? 0.5 + _glowController.value * 0.3
            : 0.0;

        return GestureDetector(
          onTap: () => widget.onTap(index),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isSelected
                  ? RadialGradient(
                      colors: [
                        AppTheme.neonBlue.withOpacity(glowIntensity),
                        AppTheme.neonPurple.withOpacity(glowIntensity * 0.7),
                        Colors.transparent,
                      ],
                    )
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.neonBlue.withOpacity(glowIntensity),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Transform.scale(
              scale: scale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with holographic effect
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                AppTheme.neonBlue,
                                AppTheme.neonPurple,
                              ],
                            )
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.neonBlue.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      item.icon,
                      size: 24,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppTheme.holographicWhite.withOpacity(0.6)
                              : AppTheme.metallicGray.withOpacity(0.6)),
                    ),
                  ),
                  
                  const SizedBox(height: 2),
                  
                  // Label with glow effect
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.neonBlue
                          : (isDark
                              ? AppTheme.holographicWhite.withOpacity(0.6)
                              : AppTheme.metallicGray.withOpacity(0.6)),
                      shadows: isSelected
                          ? [
                              Shadow(
                                color: AppTheme.neonBlue.withOpacity(0.5),
                                blurRadius: 5,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}