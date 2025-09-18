import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late List<Particle> _particles;
  late List<HolographicOrb> _orbs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _particles = List.generate(80, (index) => Particle());
    _orbs = List.generate(5, (index) => HolographicOrb());
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGradient : AppTheme.holographicGradient,
      ),
      child: Stack(
        children: [
          // Animated particles
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlesPainter(_particles, _controller.value, isDark),
                size: Size.infinite,
              );
            },
          ),
          // Holographic orbs
          AnimatedBuilder(
            animation: Listenable.merge([_controller, _pulseController]),
            builder: (context, child) {
              return CustomPaint(
                painter: HolographicOrbsPainter(
                  _orbs, 
                  _controller.value, 
                  _pulseController.value,
                  isDark,
                ),
                size: Size.infinite,
              );
            },
          ),
          // Glassmorphism overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                    ? [
                        AppTheme.neonBlue.withOpacity(0.05),
                        AppTheme.neonPurple.withOpacity(0.05),
                        AppTheme.neonPink.withOpacity(0.05),
                      ]
                    : [
                        Colors.white.withOpacity(0.1),
                        AppTheme.neonBlue.withOpacity(0.05),
                        AppTheme.neonPurple.withOpacity(0.05),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double size;
  late Color color;
  late double speed;
  late double direction;
  late double opacity;

  Particle() {
    x = math.Random().nextDouble();
    y = math.Random().nextDouble();
    size = math.Random().nextDouble() * 3 + 1;
    speed = math.Random().nextDouble() * 0.3 + 0.1;
    direction = math.Random().nextDouble() * 2 * math.pi;
    opacity = math.Random().nextDouble() * 0.6 + 0.2;
    
    final colors = [
      AppTheme.neonBlue,
      AppTheme.neonPurple,
      AppTheme.neonPink,
      AppTheme.glowingAccent,
    ];
    color = colors[math.Random().nextInt(colors.length)];
  }

  void update(double time) {
    x += math.cos(direction + time * 0.5) * speed * 0.005;
    y += math.sin(direction + time * 0.3) * speed * 0.005;
    
    if (x < 0) x = 1;
    if (x > 1) x = 0;
    if (y < 0) y = 1;
    if (y > 1) y = 0;
  }
}

class HolographicOrb {
  late double x;
  late double y;
  late double size;
  late Color color;
  late double speed;
  late double direction;

  HolographicOrb() {
    x = math.Random().nextDouble();
    y = math.Random().nextDouble();
    size = math.Random().nextDouble() * 100 + 50;
    speed = math.Random().nextDouble() * 0.1 + 0.05;
    direction = math.Random().nextDouble() * 2 * math.pi;
    
    final colors = [
      AppTheme.neonBlue,
      AppTheme.neonPurple,
      AppTheme.neonPink,
    ];
    color = colors[math.Random().nextInt(colors.length)];
  }

  void update(double time) {
    x += math.cos(direction + time * 0.2) * speed * 0.003;
    y += math.sin(direction + time * 0.15) * speed * 0.003;
    
    if (x < -0.2) x = 1.2;
    if (x > 1.2) x = -0.2;
    if (y < -0.2) y = 1.2;
    if (y > 1.2) y = -0.2;
  }
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double time;
  final bool isDark;

  ParticlesPainter(this.particles, this.time, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      particle.update(time);
      
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity * (isDark ? 0.8 : 0.4))
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size * 0.5);
      
      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          particle.y * size.height,
        ),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HolographicOrbsPainter extends CustomPainter {
  final List<HolographicOrb> orbs;
  final double time;
  final double pulse;
  final bool isDark;

  HolographicOrbsPainter(this.orbs, this.time, this.pulse, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    for (final orb in orbs) {
      orb.update(time);
      
      final center = Offset(
        orb.x * size.width,
        orb.y * size.height,
      );
      
      final radius = orb.size * (0.8 + pulse * 0.4);
      
      // Create holographic gradient
      final gradient = RadialGradient(
        colors: [
          orb.color.withOpacity((isDark ? 0.3 : 0.15) * (0.5 + pulse * 0.5)),
          orb.color.withOpacity((isDark ? 0.1 : 0.05) * (0.3 + pulse * 0.3)),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: radius),
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.3);
      
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}