import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
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

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Futuristic Logo
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.neonBlue,
                      AppTheme.neonPurple,
                      AppTheme.neonPink,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonBlue.withOpacity(0.4 + _glowController.value * 0.3),
                      blurRadius: 15 + _glowController.value * 10,
                      spreadRadius: 2 + _glowController.value * 2,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppTheme.darkSpace : Colors.white,
                  ),
                  child: Icon(
                    Icons.local_florist_rounded,
                    color: AppTheme.neonBlue,
                    size: 28,
                    shadows: [
                      Shadow(
                        color: AppTheme.neonBlue.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(width: 16),
          
          // Welcome Text with Holographic Effect
          Expanded(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً بك في المستقبل',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: (isDark ? AppTheme.holographicWhite : AppTheme.metallicGray)
                            .withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      authProvider.currentUser?.fullName ?? 'مستكشف المستقبل',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = AppTheme.neonGradient.createShader(
                            const Rect.fromLTWH(0, 0, 200, 30),
                          ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Futuristic Notifications
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(isDark ? 0.1 : 0.8),
                      Colors.white.withOpacity(isDark ? 0.05 : 0.6),
                    ],
                  ),
                  border: Border.all(
                    color: AppTheme.neonBlue.withOpacity(0.3 + _glowController.value * 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonBlue.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Navigate to notifications
                  },
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications_rounded,
                        color: isDark ? AppTheme.holographicWhite : AppTheme.metallicGray,
                        size: 24,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.neonPink, AppTheme.neonPurple],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.neonPink.withOpacity(0.6),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Futuristic Profile
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppConfig.profileRoute);
            },
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.neonBlue.withOpacity(0.3),
                            AppTheme.neonPurple.withOpacity(0.3),
                          ],
                        ),
                        border: Border.all(
                          color: AppTheme.neonBlue.withOpacity(0.5 + _glowController.value * 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.neonBlue.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: authProvider.currentUser?.profileImage != null
                            ? Image.network(
                                authProvider.currentUser!.profileImage!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.neonBlue.withOpacity(0.2),
                                      AppTheme.neonPurple.withOpacity(0.2),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.person_rounded,
                                  color: AppTheme.neonBlue,
                                  size: 24,
                                ),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}