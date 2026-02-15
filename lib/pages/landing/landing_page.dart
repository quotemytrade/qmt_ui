import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotemytrade/pages/landing/widgets/hero_section.dart';
import 'package:quotemytrade/pages/landing/widgets/why_choose_section.dart';
import 'package:quotemytrade/pages/landing/widgets/how_it_works_section.dart';
import 'package:quotemytrade/pages/landing/widgets/footer_section.dart';
import 'package:quotemytrade/widgets/common/app_bar/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: CustomAppBar(
          onGetQuoteTap: () =>
              context.go('/quote-assistance'), // ✅ NEW callback
        ),
      ),
      body: SingleChildScrollView(
        // ✅ Removed Stack + QuoteOverlay
        child: Column(
          children: [
            HeroSection(
              onGetQuoteTap: () => context.go('/quote-assistance'),
              onHowItWorksTap: () => context.go('/how-it-works'),
            ),
            const SizedBox(height: 100),
            WhyChooseSection(),
            SizedBox(height: 120),
            HowItWorksSection(),
            SizedBox(height: 80),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}
