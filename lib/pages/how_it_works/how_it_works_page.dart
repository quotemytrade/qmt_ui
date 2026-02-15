import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quotemytrade/theme/app_colors.dart';
import 'package:quotemytrade/widgets/common/app_bar/custom_app_bar.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: CustomAppBar(
          onGetQuoteTap: () => context.go('/quote-assistance'),
          onLogoTap: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.accentAlt],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'How It Works',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'This is a placeholder page for "Tradee"',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
