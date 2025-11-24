import 'package:flutter/material.dart';
import 'package:job_portal_app/screens/candidate/job_detail_screen.dart';
import 'package:job_portal_app/services/ai_service.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/search/job_search_card.dart';
import 'package:job_portal_app/widgets/common/parse_location.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> messages = [];
  List<Map<String, dynamic>> chatHistory = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    setState(() {
      messages = [
        ChatMessage(
          text:
              'Xin chào! 👋 Tôi là AI Assistant giúp bạn tìm việc phù hợp. Hãy cho tôi biết kỹ năng của bạn để tôi có thể gợi ý các công việc phù hợp.',
          isUser: false,
        ),
      ];
    });
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(text: message, isUser: true));
      isLoading = true;
    });
    _messageController.clear();

    try {
      final result = await AIService().chatWithAI(
        message,
        chatHistory: chatHistory,
      );
      if (result['success']) {
        setState(() {
          // Thêm user message vào chat history
          chatHistory.add({'role': 'user', 'content': message});

          messages.add(
            ChatMessage(
              text:
                  result['bot_message'] ??
                  result['response'] ??
                  'Không có phản hồi',
              isUser: false,
            ),
          );

          // Thêm bot message vào chat history
          chatHistory.add({
            'role': 'assistant',
            'content':
                result['bot_message'] ??
                result['response'] ??
                'Không có phản hồi',
          });

          if (result['recommendations'] != null &&
              result['recommendations'].isNotEmpty) {
            // Thêm job cards vào messages
            messages.add(
              ChatMessage(
                text: 'Các công việc phù hợp:',
                isUser: false,
                jobCards: List<Map<String, dynamic>>.from(
                  result['recommendations'],
                ),
              ),
            );
          }
        });
      } else {
        setState(() {
          messages.add(
            ChatMessage(
              text:
                  'Lỗi: ${result['error'] ?? result['message'] ?? 'Không biết'}',
              isUser: false,
            ),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          messages.add(ChatMessage(text: 'Xảy ra lỗi: $e', isUser: false));
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.smart_toy, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'AI Job Assistant',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Chat messages
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];

                      // Nếu có jobCards, hiển thị job cards
                      if (msg.jobCards != null && msg.jobCards!.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              ...msg.jobCards!.map((job) {
                                return JobSearchCard(
                                  logo: job['logo_url'] != null
                                      ? NetworkImage(job['logo_url'])
                                      : const AssetImage(
                                          "assets/default_avatar.png",
                                        ),
                                  title: job['title'],
                                  company: job['company_name'],
                                  location: parseLocation(
                                    job['work_location'],
                                  )['province']!,
                                  jobType: job['job_type'],
                                  salary: job['salary'],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => JobDetailScreen(
                                          jobId: job['job_id'],
                                          recruiterId: job['recruiter_id'],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                        );
                      }

                      // Nếu là text message
                      return Align(
                        alignment: msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.isUser
                                  ? AppColors.surface
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập kỹ năng của bạn...',
                      hintStyle: Theme.of(context).textTheme.labelSmall,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: isLoading ? null : _sendMessage,
                  icon: Icon(
                    Icons.send,
                    color: isLoading ? AppColors.hint : AppColors.primary,
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

class ChatMessage {
  final String text;
  final bool isUser;
  final List<Map<String, dynamic>>? jobCards;

  ChatMessage({required this.text, required this.isUser, this.jobCards});
}
