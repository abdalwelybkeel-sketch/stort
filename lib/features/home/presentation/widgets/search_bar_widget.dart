import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

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
    _controller.dispose();
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
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _isFocused
                    ? AppTheme.neonBlue.withOpacity(0.3 + _glowController.value * 0.2)
                    : AppTheme.neonBlue.withOpacity(0.1),
                blurRadius: _isFocused ? 20 : 10,
                spreadRadius: _isFocused ? 2 : 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          AppTheme.metallicGray.withOpacity(0.8),
                          AppTheme.darkSpace.withOpacity(0.8),
                        ]
                      : [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.7),
                        ],
                ),
                border: Border.all(
                  color: _isFocused
                      ? AppTheme.neonBlue.withOpacity(0.5 + _glowController.value * 0.3)
                      : AppTheme.neonBlue.withOpacity(0.2),
                  width: _isFocused ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: widget.onSearch,
                onTap: () => setState(() => _isFocused = true),
                onTapOutside: (_) => setState(() => _isFocused = false),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppTheme.holographicWhite : AppTheme.metallicGray,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن باقات الورود المستقبلية...',
                  hintStyle: TextStyle(
                    color: (isDark ? AppTheme.holographicWhite : AppTheme.metallicGray)
                        .withOpacity(0.6),
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.search_rounded,
                      color: _isFocused
                          ? AppTheme.neonBlue
                          : (isDark ? AppTheme.holographicWhite : AppTheme.metallicGray)
                              .withOpacity(0.6),
                      size: 24,
                    ),
                  ),
                  suffixIcon: Container(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.neonBlue, AppTheme.neonPurple],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.neonBlue.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Show filter options
                        },
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
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
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}