import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/theme/app_colors.dart';
import 'package:quotemytrade/widgets/cards/trust_badge.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return AnimatedContainer(
      duration: 12.seconds,
      padding: EdgeInsets.symmetric(
        horizontal: 32,
        vertical: isMobile ? 120 : 160,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.accentAlt],
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildHeroContent(isMobile)),
              if (!isMobile) Expanded(child: _buildHeroImage()),
            ],
          ),
          const SizedBox(height: 60),
          _buildTrustBadges(),
        ],
      ),
    );
  }

  Widget _buildHeroContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            '🟢 AI Engine Active • Quotes Updating Live',
            style: TextStyle(color: Colors.white),
          ),
        ).animate().fadeIn(),

        const SizedBox(height: 24),

        // Headline
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: isMobile ? 36 : 52,
              fontWeight: FontWeight.bold,
            ),
            children: const [
              TextSpan(
                text: 'Instant ',
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: 'AI-Powered ',
                style: TextStyle(color: AppColors.accent),
              ),
              TextSpan(
                text: 'Quotes\nfor Every Trade',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 800.ms),

        const SizedBox(height: 24),

        Text(
          'Get accurate, region-specific estimates for electricians, plumbers, painters, masons, and more — in seconds.',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 18 : 22,
            color: Colors.white.withOpacity(0.9),
          ),
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 40),

        _buildCTAButtons(),
      ],
    );
  }

  Widget _buildCTAButtons() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
          ),
          child: const Text(
            'Get Your Quote in 30 Seconds ⚡',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ).animate().scale(),

        const SizedBox(width: 24),

        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'See How It Works',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        Container(
          width: 420,
          height: 420,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Colors.cyan.withOpacity(0.4), Colors.transparent],
            ),
          ),
        ),

        Container(
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/images/HeroImage.png'),
              fit: BoxFit.contain,
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _buildTrustBadges() {
    return const Wrap(
      spacing: 40,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        TrustBadge('Used by 5,000+ tradespeople'),
        TrustBadge('Built with regional pricing intelligence'),
        TrustBadge('Estimates updated daily with AI'),
      ],
    );
  }
}
