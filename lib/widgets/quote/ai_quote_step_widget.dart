import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/core/providers/chat_provider.dart';
import 'package:quotemytrade/core/providers/quote_provider.dart';
import 'package:quotemytrade/theme/app_colors.dart';
import 'package:quotemytrade/widgets/chat/message_bubble_widget.dart';
import 'package:quotemytrade/widgets/chat/typing_indicator_widget.dart';
import 'package:quotemytrade/widgets/chat/chat_input_widget.dart';

final aiQuoteScrollControllerProvider = Provider.autoDispose<ScrollController>((
  ref,
) {
  final controller = ScrollController();
  ref.onDispose(controller.dispose);
  return controller;
});

class AIQuoteStepWidget extends ConsumerWidget {
  const AIQuoteStepWidget({super.key});

  void _scrollToBottom(ScrollController controller) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(quoteProvider.select((state) => state.location));
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final scrollController = ref.watch(aiQuoteScrollControllerProvider);

    print('Messages: ${messages.length}'); // Debug print
    print('Messages: $messages'); // See what's there
    ref.listen(chatMessagesProvider, (previous, next) {
      if (next.length != previous?.length) {
        _scrollToBottom(scrollController);
      }
    });

    ref.listen(isLoadingProvider, (previous, next) {
      if (next == true) {
        _scrollToBottom(scrollController);
      }
    });

    return Column(
      children: [
        // ✅ HEADER: Location + Refresh + Close
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location info
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (location != null)
                            Text(
                              location,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w100,
                                color: AppColors.textPrimary,
                              ),
                            )
                          else
                            Text(
                              'Select location',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ REFRESH BUTTON (resets everything)
              Tooltip(
                message: 'Start New Quote',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: AppColors.primary),
                    onPressed: isLoading
                        ? null
                        : () {
                            // ✅ FULL RESET: Chat + Quote + Location
                            ref.read(chatMessagesProvider.notifier).clearChat();
                            ref.read(chatTextControllerProvider).clear();
                            ref.read(quoteProvider.notifier).reset();
                          },
                  ),
                ),
              ),

              // ✅ CLOSE BUTTON
              // Tooltip(
              //   message: 'Close Chat',
              //   child: Container(
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.red.withOpacity(0.1),
              //     ),
              //     child: IconButton(
              //       icon: const Icon(Icons.close, color: Colors.red),
              //       onPressed: () => Navigator.of(context).pop(),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Chat messages list
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: messages.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == messages.length && isLoading) {
                return const Padding(
                  padding: EdgeInsets.only(left: 52),
                  child: TypingIndicatorWidget(),
                );
              }
              return MessageBubbleWidget(message: messages[index]);
            },
          ),
        ),

        // Chat input
        ChatInputWidget(isDisabled: isLoading),
      ],
    );
  }
}
