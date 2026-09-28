import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  final List<Map<String, String>> messages = [];

  bool isLoading = false;

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final message =
        messageController.text.trim();

    if (message.isEmpty || isLoading) {
      return;
    }

    setState(() {
      messages.add({
        'sender': 'user',
        'message': message,
      });

      isLoading = true;
    });

    messageController.clear();

    _scrollToBottom();

    try {
      final result =
          await ApiService.sendChatMessage(message);

      if (!mounted) return;

      final reply =
          result['reply']?.toString() ??
              'Sorry, I could not understand your question.';

      setState(() {
        messages.add({
          'sender': 'bot',
          'message': reply,
        });

        isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        messages.add({
          'sender': 'bot',
          'message':
              'Unable to connect to chatbot. Please try again.',
        });

        isLoading = false;
      });

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration:
            const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget buildMessage(
    Map<String, String> message,
  ) {
    final bool isUser =
        message['sender'] == 'user';

    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width *
                  0.80,
        ),
        margin:
            const EdgeInsets.only(bottom: 12),
        padding:
            const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius:
              BorderRadius.circular(15),
        ),
        child: Text(
          message['message'] ?? '',
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scheme Assistant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.smart_toy_outlined,
                          size: 80,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Hello!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Text(
                            'How can I help you find a government scheme?',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller:
                        scrollController,
                    padding:
                        const EdgeInsets.all(15),
                    itemCount: messages.length,
                    itemBuilder:
                        (context, index) {
                      return buildMessage(
                        messages[index],
                      );
                    },
                  ),
          ),

          if (isLoading)
            const Padding(
              padding:
                  EdgeInsets.only(bottom: 8),
              child: Text(
                'Scheme Assistant is typing...',
              ),
            ),

          Padding(
            padding:
                const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        messageController,
                    textInputAction:
                        TextInputAction.send,
                    onSubmitted: (_) {
                      sendMessage();
                    },
                    decoration:
                        InputDecoration(
                      hintText:
                          'Ask something...',
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                SizedBox(
                  height: 52,
                  width: 52,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : sendMessage,
                    child: const Icon(
                      Icons.send,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}