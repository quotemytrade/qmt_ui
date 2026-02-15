import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as ref;
import 'package:quotemytrade/core/models/chat_message.dart';
import 'package:quotemytrade/core/providers/chat_provider.dart';

// Add to your existing quote_provider.dart

// Add these to quote_provider.dart
import 'package:quotemytrade/core/providers/chat_provider.dart';

final hasEstimationProvider = Provider.autoDispose<bool>((ref) {
  final messages = ref.watch(chatMessagesProvider);
  return messages.any((msg) => msg.estimation != null);
});

final lastEstimationProvider = Provider.autoDispose((ref) {
  final messages = ref.watch(chatMessagesProvider);
  try {
    return messages.lastWhere((msg) => msg.estimation != null).estimation;
  } catch (e) {
    return null;
  }
});

class QuoteState {
  final int currentStep;
  final String? location;
  final List<ChatMessage> chatMessages;
  final bool isAIGenerating;

  const QuoteState({
    this.currentStep = 0,
    this.location,
    this.chatMessages = const [],
    this.isAIGenerating = false,
  });

  QuoteState copyWith({
    int? currentStep,
    String? location,
    List<ChatMessage>? chatMessages,
    bool? isAIGenerating,
  }) {
    return QuoteState(
      currentStep: currentStep ?? this.currentStep,
      location: location ?? this.location,
      chatMessages: chatMessages ?? this.chatMessages,
      isAIGenerating: isAIGenerating ?? this.isAIGenerating,
    );
  }
}

class QuoteNotifier extends StateNotifier<QuoteState> {
  QuoteNotifier() : super(const QuoteState());

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

  void clearLocation() {
    state = state.copyWith(location: null);
  }

  void nextStep() {
    if (state.currentStep < 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void addChatMessage(ChatMessage message) {
    state = state.copyWith(chatMessages: [...state.chatMessages, message]);
  }

  void setGenerating(bool generating) {
    state = state.copyWith(isAIGenerating: generating);
  }

  void reset() {
    state = const QuoteState();
  }
}

final quoteProvider = StateNotifierProvider<QuoteNotifier, QuoteState>((ref) {
  return QuoteNotifier();
});
