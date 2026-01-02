import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotemytrade/theme/app_colors.dart';
import 'package:quotemytrade/theme/app_theme.dart';

final getQuoteOverlayProvider = StateProvider<bool>((ref) => false);

void main() {
  //runApp(const MyApp());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuoteMyTrade',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LandingPage(),
    );
  }
}

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: ClipRRect(
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
                    // LOGO AREA
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.accent,
                                    AppColors.accentAlt,
                                  ],
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
                          ],
                        ),
                        Row(
                          children: [
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
                                '🟢 AI Live',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // NAV + CTA
                    Row(
                      children: [
                        _NavItem('Home'),
                        _NavItem('How It Works'),
                        _NavItem('Pricing'),
                        _NavItem('About'),
                        const SizedBox(width: 24),

                        // CTA BUTTON
                        ElevatedButton(
                          onPressed: () {
                            ref.read(getQuoteOverlayProvider.notifier).state =
                                true;
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
                            'Get Quote ⚡',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // ================= BODY ===================
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // ================= HERO =================
                AnimatedContainer(
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // AI Indicator
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
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
                                        style: TextStyle(
                                          color: AppColors.accent,
                                        ),
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

                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accent,
                                        foregroundColor: AppColors.textPrimary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 20,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        elevation: 10,
                                      ),
                                      child: const Text(
                                        'Get Your Quote in 30 Seconds ⚡',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ).animate().scale(),
                                    const SizedBox(width: 24),
                                    OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 20,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'See How It Works',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          if (!isMobile)
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Glow
                                  Container(
                                    width: 420,
                                    height: 420,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors.cyan.withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 500,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 20,
                                        ),
                                      ],
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/HeroImage.png',
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ).animate().fadeIn(delay: 600.ms),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 60),

                      Wrap(
                        spacing: 40,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: const [
                          _TrustBadge('Used by 5,000+ tradespeople'),
                          _TrustBadge(
                            'Built with regional pricing intelligence',
                          ),
                          _TrustBadge('Estimates updated daily with AI'),
                        ],
                      ),
                    ],
                  ),
                ),

                // ===== EVERYTHING BELOW IS UNCHANGED =====
                const SizedBox(height: 100),

                // Why Choose
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        'Why Choose QuoteMyTrade?',
                        style: GoogleFonts.inter(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Wrap(
                        spacing: 32,
                        runSpacing: 32,
                        alignment: WrapAlignment.center,
                        children: const [
                          _ModernFeatureCard(
                            color: AppColors.accent,
                            icon: Icons.auto_awesome,
                            title: 'AI-Driven Accuracy',
                            description:
                                'Smart quotes powered by real-time market data.',
                          ),
                          _ModernFeatureCard(
                            color: AppColors.primary,
                            icon: Icons.location_on,
                            title: 'Region-Specific Pricing',
                            description:
                                'Local rates, rules, and standards built-in.',
                          ),
                          _ModernFeatureCard(
                            color: AppColors.accentAlt,
                            icon: Icons.verified,
                            title: 'Professional Estimates',
                            description: 'Client-ready quotes that win trust.',
                          ),
                          _ModernFeatureCard(
                            color: AppColors.accent,
                            icon: Icons.build,
                            title: 'All Trades Covered',
                            description:
                                'Electrical, plumbing, painting & more.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120),

                // How it works
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 100,
                    horizontal: 32,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'How It Works',
                        style: GoogleFonts.inter(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          _StepCard(
                            number: '1',
                            title: 'Select Trade & Location',
                            icon: Icons.category,
                          ),
                          _StepCard(
                            number: '2',
                            title: 'Enter Job Details',
                            icon: Icons.edit_note,
                          ),
                          _StepCard(
                            number: '3',
                            title: 'Get Instant AI Quote',
                            icon: Icons.flash_on,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Footer unchanged
                const SizedBox(height: 80),
                Container(
                  color: AppColors.darkBackground,
                  padding: const EdgeInsets.symmetric(
                    vertical: 60,
                    horizontal: 32,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'QuoteMyTrade',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'AI-powered quotes that save time & win jobs.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Privacy Policy',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 32),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Terms of Service',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 32),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Contact',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        '© 2026 QuoteMyTrade. All rights reserved.',
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const GetQuoteInlineOverlay(),
        ],
      ),
    );
  }
}

// ===== SUPPORTING WIDGETS (UNCHANGED) =====

class GetQuoteInlineOverlay extends ConsumerWidget {
  const GetQuoteInlineOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(getQuoteOverlayProvider);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    if (!isOpen) return const SizedBox.shrink();

    return Stack(
      children: [
        /// BLUR BACKDROP
        GestureDetector(
          onTap: () => ref.read(getQuoteOverlayProvider.notifier).state = false,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
        ),

        /// SLIDE-UP PANEL
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedSlide(
            offset: const Offset(0, 0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: isMobile
                  ? MediaQuery.of(context).size.height * 0.92
                  : 640,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  /// DRAG HANDLE
                  const SizedBox(height: 12),
                  Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  /// HEADER
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AI Quote Assistant',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () =>
                              ref.read(getQuoteOverlayProvider.notifier).state =
                                  false,
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  /// CHAT CONTENT
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: const [
                                _ChatBubble(
                                  isBot: true,
                                  text:
                                      'Hi 👋 I’m your AI Quote Assistant.\nWhat trade do you need help with?',
                                ),
                                SizedBox(height: 16),
                                _ChatBubble(isBot: false, text: 'Electrician'),
                                SizedBox(height: 16),
                                _ChatBubble(
                                  isBot: true,
                                  text:
                                      'Great! ⚡ Please share your location and job details.',
                                ),
                              ],
                            ),
                          ),

                          /// INPUT BAR
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Type your response…',
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
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
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final String text;
  const _TrustBadge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final IconData icon;
  const _StepCard({
    required this.number,
    required this.title,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Icon(icon, size: 60, color: AppColors.accent),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ModernFeatureCard extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String description;
  const _ModernFeatureCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
  });
  @override
  State<_ModernFeatureCard> createState() => _ModernFeatureCardState();
}

class _ModernFeatureCardState extends State<_ModernFeatureCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 300,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.color.withOpacity(0.1), Colors.white],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            _hovered
                ? BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 20,
                  )
                : BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                  ),
          ],
        ),
        transform: Matrix4.identity()..scale(_hovered ? 1.05 : 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(widget.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String text;
  const _NavItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}

class GetQuotePage extends StatelessWidget {
  const GetQuotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      extendBodyBehindAppBar: true,

      // SAME glass header
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.7),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Icon(
                      Icons.build_circle,
                      color: AppColors.primary,
                      size: 36,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'QuoteMyTrade',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: isMobile ? 120 : 140,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.accentAlt],
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            height: isMobile ? null : 560,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              children: [
                // Title
                Text(
                  'AI Quote Assistant',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Answer a few questions to get an instant estimate',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                // Chat area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _ChatBubble(
                          isBot: true,
                          text:
                              'Hi 👋 I’m your AI Quote Assistant.\nWhat trade do you need help with?',
                        ),
                        SizedBox(height: 16),
                        _ChatBubble(isBot: false, text: 'Electrician'),
                        SizedBox(height: 16),
                        _ChatBubble(
                          isBot: true,
                          text:
                              'Great! ⚡ Please share your location and job details.',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Input bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Type your response…',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final bool isBot;
  final String text;

  const _ChatBubble({required this.isBot, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: isBot ? AppColors.chatBubbleBorder : AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isBot ? AppColors.darkBackground : Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
