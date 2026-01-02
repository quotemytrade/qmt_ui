import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotemytrade/pages/landing/widgets/hero_section.dart';
import 'package:quotemytrade/pages/landing/widgets/why_choose_section.dart';
import 'package:quotemytrade/pages/landing/widgets/how_it_works_section.dart';
import 'package:quotemytrade/pages/landing/widgets/footer_section.dart';
import 'package:quotemytrade/pages/quote/widgets/quote_overlay.dart';
import 'package:quotemytrade/widgets/common/app_bar/custom_app_bar.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: const [
                HeroSection(),
                SizedBox(height: 100),
                WhyChooseSection(),
                SizedBox(height: 120),
                HowItWorksSection(),
                SizedBox(height: 80),
                FooterSection(),
              ],
            ),
          ),
          const QuoteOverlay(),
        ],
      ),
    );
  }
}
