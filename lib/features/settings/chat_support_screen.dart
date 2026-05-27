import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/widgets.dart';

/// FRS 107 — Chat Support. Mock conversation with a local send action.
class ChatSupportScreen extends StatefulWidget {
  const ChatSupportScreen({super.key});

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final _controller = TextEditingController();
  final List<({String text, bool fromUser})> _messages = [
    (text: 'Hi! Welcome to Riण support. How can we help you today?', fromUser: false),
    (text: 'I have a question about my credit balance.', fromUser: true),
    (text: 'Sure — credits are used when you send loan offers. Your current balance is shown in Settings. What would you like to know?', fromUser: false),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add((text: text, fromUser: true));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar('Chat Support'),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            color: AppColors.successLight,
            child: Text(
              '● Support is online — Average response: 2 min',
              style: AppText.bodyMD.copyWith(color: AppColors.successPrimary),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _Bubble(
                text: _messages[i].text,
                fromUser: _messages[i].fromUser,
              ),
            ),
          ),
          StickyBottomBar(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: AppText.bodyMD
                        .copyWith(color: AppColors.textPrimary),
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: AppText.bodyMD
                          .copyWith(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.bgTertiary,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.pill),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.tealPrimary),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.fromUser});
  final String text;
  final bool fromUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: fromUser ? AppColors.navyPrimary : AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: fromUser
              ? null
              : Border.all(color: AppColors.borderLight, width: 0.5),
        ),
        child: Text(
          text,
          style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
