import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../splash/presentation/widgets/animated_background.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/futuristic_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentNavIndex = 0;

  final List<String> _bannerImages = [
    'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg',
    'https://images.pexels.com/photos/1022385/pexels-photo-1022385.jpeg',
    'https://images.pexels.com/photos/1181534/pexels-photo-1181534.jpeg',
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'باقات الحب',
      'icon': Icons.favorite,
      'color': AppTheme.neonPink,
      'image': 'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg',
    },
    {
      'name': 'باقات الزفاف',
      'icon': Icons.celebration,
      'color': AppTheme.neonPurple,
      'image': 'https://images.pexels.com/photos/1022385/pexels-photo-1022385.jpeg',
    },
    {
      'name': 'باقات التخرج',
      'icon': Icons.school,
      'color': AppTheme.neonBlue,
      'image': 'https://images.pexels.com/photos/1181534/pexels-photo-1181534.jpeg',
    },
    {
      'name': 'باقات المناسبات',
      'icon': Icons.cake,
      'color': AppTheme.cyberYellow,
      'image': 'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadData();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
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

  Future<void> _loadData() async {
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await productsProvider.loadProducts();
    if (authProvider.isAuthenticated) {
      await cartProvider.loadCart(authProvider.currentUser!.id);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  slivers: [
                    // App Bar
                    const SliverToBoxAdapter(
                      child: HomeAppBar(),
                    ),

                    // Search Bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SearchBarWidget(
                          onSearch: (query) {
                            Navigator.pushNamed(
                              context,
                              '/products',
                              arguments: {'search': query},
                            );
                          },
                        ),
                      ),
                    ),

                    // Banner Carousel
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 220,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9,
                            autoPlayInterval: const Duration(seconds: 4),
                            autoPlayCurve: Curves.easeInOutCubic,
                          ),
                          items: _bannerImages.map((image) {
                            return AnimatedBuilder(
                              animation: _glowController,
                              builder: (context, child) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.neonBlue.withOpacity(
                                          0.3 + _glowController.value * 0.2,
                                        ),
                                        blurRadius: 20 + _glowController.value * 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          image,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.7),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Holographic overlay
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppTheme.neonBlue.withOpacity(0.1),
                                                AppTheme.neonPurple.withOpacity(0.1),
                                                AppTheme.neonPink.withOpacity(0.1),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 24,
                                          right: 24,
                                          left: 24,
                                          child: Text(
                                            'عروض خاصة على باقات الورود المستقبلية',
                                            style: theme.textTheme.headlineSmall?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  color: AppTheme.neonBlue.withOpacity(0.5),
                                                  blurRadius: 10,
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
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // Categories Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الفئات المستقبلية',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = AppTheme.neonGradient.createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70),
                                  ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 140,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                itemBuilder: (context, index) {
                                  final category = _categories[index];
                                  return CategoryCard(
                                    name: category['name'],
                                    icon: category['icon'],
                                    color: category['color'],
                                    image: category['image'],
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/products',
                                        arguments: {'category': category['name']},
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Featured Products
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'المنتجات المميزة',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = AppTheme.neonGradient.createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70),
                                  ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.neonBlue.withOpacity(0.1),
                                    AppTheme.neonPurple.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/products');
                                },
                                child: Text(
                                  'عرض الكل',
                                  style: TextStyle(
                                    color: AppTheme.neonBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Products Grid
                    Consumer<ProductsProvider>(
                      builder: (context, productsProvider, child) {
                        if (productsProvider.isLoading) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.neonBlue,
                                  ),
                                  strokeWidth: 3,
                                ),
                              ),
                            ),
                          );
                        }

                        final featuredProducts = productsProvider.products
                            .where((product) => product.isFeatured)
                            .take(6)
                            .toList();

                        if (featuredProducts.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.local_florist_outlined,
                                      size: 80,
                                      color: theme.colorScheme.onBackground.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'لا توجد منتجات مميزة حالياً',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: const EdgeInsets.all(20),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product = featuredProducts[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppConfig.productDetailsRoute,
                                      arguments: {'productId': product.id},
                                    );
                                  },
                                );
                              },
                              childCount: featuredProducts.length,
                            ),
                          ),
                        );
                      },
                    ),

                    // Bottom Spacing for Navigation
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 120),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FuturisticBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          _handleNavigation(index);
        },
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/products');
        break;
      case 2:
        Navigator.pushNamed(context, AppConfig.cartRoute);
        break;
      case 3:
        Navigator.pushNamed(context, AppConfig.ordersRoute);
        break;
      case 4:
        Navigator.pushNamed(context, AppConfig.profileRoute);
        break;
    }
  }
}