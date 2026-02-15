import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/core/providers/app_providers.dart';
import 'package:quotemytrade/core/providers/auth_provider.dart';
import 'package:quotemytrade/theme/app_colors.dart';
import 'package:quotemytrade/widgets/auth/login_dialog.dart';
import 'package:quotemytrade/widgets/common/app_bar/nav_item.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback? onGetQuoteTap;
  final VoidCallback? onLogoTap;
  const CustomAppBar({super.key, this.onGetQuoteTap, this.onLogoTap});

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
            color: Colors.white.withOpacity(0.15),
            // gradient: const LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [AppColors.primary, AppColors.secondary],
            // ),
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
              children: [_buildLogo(context), _buildNavigation(ref)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return GestureDetector(
      onTap: onLogoTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              // gradient: const LinearGradient(
              //   colors: [AppColors.accent, AppColors.accentAlt],
              // ),
              boxShadow: [
                BoxShadow(color: Colors.white.withOpacity(0.6), blurRadius: 12),
              ],
            ),
            child: const Icon(Icons.build, color: Colors.black, size: 26),
          ),
          const SizedBox(width: 14),
          Text(
            'QuoteMyTrade',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.accent,
              letterSpacing: -0.5,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '🟢 AI Live',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Row(
      children: [
        const NavItem('Home'),
        const NavItem('How It Works'),
        const NavItem('Pricing'),
        const NavItem('About'),
        const SizedBox(width: 24),
        currentUser.when(
          data: (user) {
            if (user != null) {
              // User is logged in - show logout button
              return PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'logout') {
                    await ref.read(authProvider.notifier).logout();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.accent, width: 1),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.accent,
                        child: Text(
                          (user.displayName?.isNotEmpty ?? false)
                              ? user.displayName![0].toUpperCase()
                              : (user.email![0].toUpperCase()),
                          style: const TextStyle(
                            color: AppColors.darkBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        user.displayName ?? user.email?.split('@')[0] ?? 'User',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: const Text('Logout'),
                  ),
                ],
              );
            } else {
              // User is not logged in - show login button
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: ref.context,
                    builder: (context) => const LoginDialog(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.darkBackground,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 12,
                  shadowColor: Colors.cyanAccent,
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              );
            }
          },
          loading: () => const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (error, stack) => ElevatedButton(
            onPressed: () {
              showDialog(
                context: ref.context,
                builder: (context) => const LoginDialog(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.darkBackground,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 12,
              shadowColor: Colors.cyanAccent,
            ),
            child: const Text(
              'Log In',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
