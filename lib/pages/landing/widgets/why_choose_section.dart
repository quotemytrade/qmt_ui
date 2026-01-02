import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/theme/app_colors.dart';
import 'package:quotemytrade/widgets/cards/feature_card.dart';

class WhyChooseSection extends StatelessWidget {
  const WhyChooseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            'Why Choose QuoteMyTrade?',
            style: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 60),
          const Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: [
              FeatureCard(
                color: AppColors.accent,
                icon: Icons.auto_awesome,
                title: 'AI-Driven Accuracy',
                description: 'Smart quotes powered by real-time market data.',
              ),
              FeatureCard(
                color: AppColors.primary,
                icon: Icons.location_on,
                title: 'Region-Specific Pricing',
                description: 'Local rates, rules, and standards built-in.',
              ),
              FeatureCard(
                color: AppColors.accentAlt,
                icon: Icons.verified,
                title: 'Professional Estimates',
                description: 'Client-ready quotes that win trust.',
              ),
              FeatureCard(
                color: AppColors.accent,
                icon: Icons.build,
                title: 'All Trades Covered',
                description: 'Electrical, plumbing, painting & more.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
