import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/product_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
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
          final scale = 1.0 + _hoverController.value * 0.03;
          final elevation = 5.0 + _hoverController.value * 15.0;

          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.neonBlue.withOpacity(0.2 + _hoverController.value * 0.3),
                    blurRadius: elevation,
                    spreadRadius: 2,
                    offset: Offset(0, elevation * 0.3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppTheme.metallicGray.withOpacity(0.8),
                              AppTheme.darkSpace.withOpacity(0.9),
                            ]
                          : [
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.7),
                            ],
                    ),
                    border: Border.all(
                      color: AppTheme.neonBlue.withOpacity(0.2 + _hoverController.value * 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            Hero(
                              tag: 'product_${widget.product.id}',
                              child: CachedNetworkImage(
                                imageUrl: widget.product.images.isNotEmpty 
                                    ? widget.product.images.first 
                                    : 'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.neonBlue.withOpacity(0.1),
                                        AppTheme.neonPurple.withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme.neonBlue,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.neonBlue.withOpacity(0.1),
                                        AppTheme.neonPurple.withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.local_florist,
                                    color: AppTheme.neonBlue,
                                    size: 40,
                                  ),
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
                            
                            // Discount Badge
                            if (widget.product.hasDiscount)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [AppTheme.neonPink, Colors.red],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.neonPink.withOpacity(0.5),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${widget.product.discount!.toInt()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            
                            // Favorite Button
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    // TODO: Add to favorites
                                  },
                                  icon: Icon(
                                    Icons.favorite_border_rounded,
                                    color: AppTheme.neonPink,
                                    size: 20,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Product Info
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name
                              Text(
                                widget.product.name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppTheme.holographicWhite : AppTheme.metallicGray,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 6),
                              
                              // Rating
                              Row(
                                children: [
                                  ...List.generate(5, (index) {
                                    return Icon(
                                      index < widget.product.rating.floor()
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: AppTheme.cyberYellow,
                                      size: 16,
                                    );
                                  }),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${widget.product.reviewCount})',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: (isDark ? AppTheme.holographicWhite : AppTheme.metallicGray)
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const Spacer(),
                              
                              // Price and Add to Cart
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (widget.product.hasDiscount)
                                        Text(
                                          '${widget.product.price.toInt()} ر.س',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            decoration: TextDecoration.lineThrough,
                                            color: (isDark ? AppTheme.holographicWhite : AppTheme.metallicGray)
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      Text(
                                        '${widget.product.finalPrice.toInt()} ر.س',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..shader = LinearGradient(
                                              colors: [AppTheme.neonBlue, AppTheme.neonPurple],
                                            ).createShader(const Rect.fromLTWH(0, 0, 100, 20)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  Consumer2<CartProvider, AuthProvider>(
                                    builder: (context, cartProvider, authProvider, child) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [AppTheme.neonBlue, AppTheme.neonPurple],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.neonBlue.withOpacity(0.4),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
                                            if (!authProvider.isAuthenticated) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('يرجى تسجيل الدخول أولاً'),
                                                ),
                                              );
                                              return;
                                            }
                                            
                                            await cartProvider.addToCart(
                                              userId: authProvider.currentUser!.id,
                                              productId: widget.product.id,
                                              productName: widget.product.name,
                                              productImage: widget.product.images.isNotEmpty 
                                                  ? widget.product.images.first 
                                                  : '',
                                              price: widget.product.finalPrice,
                                              quantity: 1,
                                            );
                                            
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('تم إضافة ${widget.product.name} للسلة'),
                                                backgroundColor: AppTheme.neonBlue,
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.add_shopping_cart_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 40,
                                            minHeight: 40,
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}