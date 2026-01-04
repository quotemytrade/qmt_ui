import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotemytrade/core/models/chat_message.dart';
import 'package:quotemytrade/core/services/ai_service.dart';
import 'package:quotemytrade/core/services/location_service.dart';

final aiServiceProvider = Provider((ref) => AiService());
final locationServiceProvider = Provider((ref) => LocationService());

final chatMessagesProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
      return ChatNotifier(ref);
    });

final isLoadingProvider = StateProvider<bool>((ref) => false);

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref ref;

  ChatNotifier(this.ref) : super([]) {
    _addInitialMessage();
  }

  void _addInitialMessage() {
    state = [
      ChatMessage(
        text:
            "Hello! 👋 I'm your QuoteMyTrade AI assistant. I can help you estimate costs for various trades work including electrical, plumbing, painting, masonry, and more. Describe the job or upload a photo, and I'll provide a detailed, itemized estimate.",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  Future<void> sendTextMessage(String text) async {
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    addMessage(userMessage);

    ref.read(isLoadingProvider.notifier).state = true;

    final locationService = ref.read(locationServiceProvider);
    final locationHint = await locationService.getUserLocationHint();

    final aiService = ref.read(aiServiceProvider);
    final result = await aiService.sendMessage(
      text: text,
      locationHint: locationHint,
    );

    ref.read(isLoadingProvider.notifier).state = false;

    if (result['success'] == true) {
      final aiMessage = ChatMessage(
        text: result['responseText'],
        isUser: false,
        timestamp: DateTime.now(),
        estimation: result['estimation'],
      );
      addMessage(aiMessage);
    } else {
      final errorMessage = ChatMessage(
        text: result['error'] ?? 'Failed to get response. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      addMessage(errorMessage);
    }
  }

  Future<void> sendImageMessage(Uint8List imageBytes) async {
    final imageMessage = ChatMessage(
      text: "Uploaded photo for cost estimation",
      isUser: true,
      timestamp: DateTime.now(),
      imageBytes: imageBytes,
    );
    addMessage(imageMessage);

    ref.read(isLoadingProvider.notifier).state = true;

    final locationService = ref.read(locationServiceProvider);
    final locationHint = await locationService.getUserLocationHint();

    final basePrompt =
        "Analyze this renovation/construction photo carefully and provide a detailed, itemized cost estimate for the visible work needed.";

    final aiService = ref.read(aiServiceProvider);
    final result = await aiService.sendMessage(
      text: basePrompt,
      imageBytes: imageBytes,
      locationHint: locationHint,
    );

    ref.read(isLoadingProvider.notifier).state = false;

    if (result['success'] == true) {
      final aiMessage = ChatMessage(
        text: result['responseText'],
        isUser: false,
        timestamp: DateTime.now(),
        estimation: result['estimation'],
      );
      addMessage(aiMessage);
    } else {
      final errorMessage = ChatMessage(
        text: result['error'] ?? 'Failed to analyze image. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      addMessage(errorMessage);
    }
  }

  void clearChat() {
    ref.read(aiServiceProvider).clearHistory();
    _addInitialMessage();
  }
}
