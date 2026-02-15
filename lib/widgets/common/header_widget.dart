import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/theme/app_colors.dart';

class PersistentHeader extends ConsumerWidget implements PreferredSizeWidget {
  const PersistentHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondary],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo - navigates to home
                GestureDetector(
                  onTap: () => context.go('/'),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.accent, AppColors.accentAlt],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.6),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.build,
                          color: Colors.black,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'QuoteMyTrade',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'AI Live',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right side actions (optional)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.help_outline, color: Colors.white),
                      onPressed: () {
                        // Help modal or dialog
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.white),
                      onPressed: () {
                        // Contact action
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
