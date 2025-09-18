import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../splash/presentation/widgets/animated_background.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _glowController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      if (authProvider.currentUser?.isVendor == true) {
        Navigator.pushReplacementNamed(context, AppConfig.vendorDashboardRoute);
      } else {
        Navigator.pushReplacementNamed(context, AppConfig.homeRoute);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();

    if (success && mounted) {
      if (authProvider.currentUser?.isVendor == true) {
        Navigator.pushReplacementNamed(context, AppConfig.vendorDashboardRoute);
      } else {
        Navigator.pushReplacementNamed(context, AppConfig.homeRoute);
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithApple();

    if (success && mounted) {
      if (authProvider.currentUser?.isVendor == true) {
        Navigator.pushReplacementNamed(context, AppConfig.vendorDashboardRoute);
      } else {
        Navigator.pushReplacementNamed(context, AppConfig.homeRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      
                      // Futuristic Logo
                      Hero(
                        tag: 'app_logo',
                        child: AnimatedBuilder(
                          animation: _glowController,
                          builder: (context, child) {
                            return Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.neonBlue,
                                    AppTheme.neonPurple,
                                    AppTheme.neonPink,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.neonBlue.withOpacity(0.4 + _glowController.value * 0.3),
                                    blurRadius: 30 + _glowController.value * 20,
                                    spreadRadius: 5 + _glowController.value * 5,
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark ? AppTheme.darkSpace : Colors.white,
                                ),
                                child: Icon(
                                  Icons.local_florist_rounded,
                                  size: 60,
                                  color: AppTheme.neonBlue,
                                  shadows: [
                                    Shadow(
                                      color: AppTheme.neonBlue.withOpacity(0.8),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Welcome Text
                      Text(
                        l10n.welcome,
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = AppTheme.neonGradient.createShader(
                              const Rect.fromLTWH(0, 0, 300, 70),
                            ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        'ادخل إلى عالم المستقبل من باقات الورود',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: (isDark ? AppTheme.holographicWhite : AppTheme.metallicGray)
                              .withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Login Form with Glassmorphism
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    AppTheme.metallicGray.withOpacity(0.3),
                                    AppTheme.darkSpace.withOpacity(0.3),
                                  ]
                                : [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                          ),
                          border: Border.all(
                            color: AppTheme.neonBlue.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neonBlue.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                AuthTextField(
                                  controller: _emailController,
                                  label: l10n.email,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email_rounded,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'يرجى إدخال البريد الإلكتروني';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value!)) {
                                      return 'البريد الإلكتروني غير صحيح';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 24),
                                
                                AuthTextField(
                                  controller: _passwordController,
                                  label: l10n.password,
                                  isPassword: true,
                                  prefixIcon: Icons.lock_rounded,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'يرجى إدخال كلمة المرور';
                                    }
                                    if (value!.length < 6) {
                                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 32),
                                
                                // Futuristic Login Button
                                Consumer<AuthProvider>(
                                  builder: (context, authProvider, child) {
                                    return AnimatedBuilder(
                                      animation: _glowController,
                                      builder: (context, child) {
                                        return Container(
                                          width: double.infinity,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppTheme.neonBlue,
                                                AppTheme.neonPurple,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(28),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.neonBlue.withOpacity(
                                                  0.4 + _glowController.value * 0.3,
                                                ),
                                                blurRadius: 15 + _glowController.value * 10,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: authProvider.isLoading 
                                                ? null 
                                                : _handleLogin,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(28),
                                              ),
                                            ),
                                            child: authProvider.isLoading
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                        Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                : Text(
                                                    l10n.login,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                
                                // Error Message
                                Consumer<AuthProvider>(
                                  builder: (context, authProvider, child) {
                                    if (authProvider.errorMessage != null) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Colors.red.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Text(
                                            authProvider.errorMessage!,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Social Login
                      Text(
                        'أو ادخل باستخدام',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: (isDark ? AppTheme.holographicWhite : AppTheme.metallicGray)
                              .withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Row(
                        children: [
                          Expanded(
                            child: SocialLoginButton(
                              icon: Icons.g_mobiledata_rounded,
                              label: 'Google',
                              onPressed: _handleGoogleSignIn,
                              backgroundColor: Colors.white,
                              textColor: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SocialLoginButton(
                              icon: Icons.apple_rounded,
                              label: 'Apple',
                              onPressed: _handleAppleSignIn,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ليس لديك حساب؟ ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppTheme.holographicWhite : AppTheme.metallicGray,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      const RegisterPage(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOutCubic,
                                      )),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(
                              l10n.register,
                              style: TextStyle(
                                foreground: Paint()
                                  ..shader = AppTheme.neonGradient.createShader(
                                    const Rect.fromLTWH(0, 0, 100, 20),
                                  ),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}