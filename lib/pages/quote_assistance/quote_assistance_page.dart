import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:quotemytrade/core/providers/quote_provider.dart';
import 'package:quotemytrade/core/providers/chat_provider.dart';
import 'package:quotemytrade/core/services/ai_service.dart';
import 'package:quotemytrade/theme/app_colors.dart';
import 'package:quotemytrade/widgets/common/header_widget.dart';
import 'package:quotemytrade/widgets/quote/stepper_widget.dart';
import 'package:quotemytrade/widgets/quote/location_step_widget.dart';
import 'package:quotemytrade/widgets/quote/ai_quote_step_widget.dart';

class QuoteAssistancePage extends ConsumerWidget {
  const QuoteAssistancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reset on first load
    ref.listen(quoteProvider, (previous, next) {
      if (previous == null) {
        // Only reset on first load
        ref.read(quoteProvider.notifier).reset();
        ref.read(chatMessagesProvider.notifier).resetForQuote();
      }
    });
    //ref.read(chatMessagesProvider.notifier).resetForQuote();

    final currentStep = ref.watch(
      quoteProvider.select((state) => state.currentStep),
    );
    final location = ref.watch(quoteProvider.select((state) => state.location));
    final hasEstimation = ref.watch(hasEstimationProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(88),
        child: PersistentHeader(),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFF), Color(0xFFEFF5FF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Stepper (top)
                const QuoteStepperWidget(),

                const SizedBox(height: 32),

                // Main content area
                Expanded(
                  child: Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Step title
                          Text(
                            _getStepTitle(currentStep),
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Step subtitle
                          Text(
                            _getStepSubtitle(currentStep),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Step content (conditional)
                          Expanded(child: _buildStepContent(currentStep)),

                          // ✅ SMART ACTION BUTTONS - Show based on context
                          if (currentStep == 0)
                            _buildLocationButtons(context, ref)
                          else if (currentStep == 1 && !hasEstimation)
                            _buildChatButtons(context, ref)
                          else if (currentStep == 1 && hasEstimation)
                            _buildActionButtons(context, ref, isLoading),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    const titles = ['Where are you located?', 'AI Quote Assistance'];
    return titles[step];
  }

  String _getStepSubtitle(int step) {
    const subtitles = [
      'Enter your city or address for accurate local pricing',
      'Describe your project and get instant AI-powered estimate',
    ];
    return subtitles[step];
  }

  Widget _buildStepContent(int currentStep) {
    switch (currentStep) {
      case 0:
        return const LocationStepWidget();
      case 1:
        return const AIQuoteStepWidget();
      default:
        return const Center(child: Text('Step not implemented'));
    }
  }

  // ✅ STEP 1: Location buttons
  Widget _buildLocationButtons(BuildContext context, WidgetRef ref) {
    final hasLocation = ref.watch(
      quoteProvider.select((state) => state.location != null),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.go('/'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('Back', style: GoogleFonts.inter(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: !hasLocation
                  ? null
                  : () => ref.read(quoteProvider.notifier).nextStep(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: Text(
                'Next',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ STEP 2: Chat buttons (before estimation)
  Widget _buildChatButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => ref.read(quoteProvider.notifier).previousStep(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('Back', style: GoogleFonts.inter(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                // User continues typing in chat - input handles it
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: Text(
                'Ask Question',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ STEP 2: Action buttons (after estimation received)
  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          // Top row: Refine + Download + Share
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Refine'),
                  onPressed: isLoading ? null : () => _refineQuote(ref),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                  onPressed: isLoading ? null : () => _downloadQuote(ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  onPressed: isLoading ? null : () => _shareQuote(ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bottom: Back to Home
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Back to Home',
                style: GoogleFonts.inter(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Action handlers
  void _refineQuote(WidgetRef ref) {
    // Clear input and focus for user to type refinement
    ref.read(chatTextControllerProvider).clear();
    // User can now type "Can you reduce..." or "Use cheaper materials..."
  }

  void _downloadQuote(WidgetRef ref) {
    final lastEstimation = ref.read(lastEstimationProvider);
    if (lastEstimation != null) {
      // Call your PDF service
      final pdfService = ref.read(pdfServiceProvider);
      pdfService.generateAndSharePdf(lastEstimation, share: false);
    }
  }

  void _shareQuote(WidgetRef ref) {
    final lastEstimation = ref.read(lastEstimationProvider);
    if (lastEstimation != null) {
      final aiService = ref.read(pdfServiceProvider);
      aiService.generateAndSharePdf(lastEstimation, share: true);
    }
  }
}
