import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/features/chat/presentation/cubits/chat_cubit.dart';
import 'package:ala_feen/core/services/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  final String tripId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.tripId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    // Tell the notification service that this chat is now active
    ChatNotificationService().setChatScreenActive(widget.tripId);
  }

  @override
  void dispose() {
    // Tell the notification service that the chat is no longer active
    ChatNotificationService().setChatScreenInactive();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatCubit>()..getMessages(widget.tripId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.otherUserName),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatSuccess) {
                    if (state.sendError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.sendError!)),
                      );
                    }
                    // Auto-scroll when new messages arrive
                    if (state.messages.length > _previousMessageCount) {
                      _scrollToBottom();
                    }
                    _previousMessageCount = state.messages.length;
                  }
                },
                builder: (context, state) {
                  if (state is ChatSuccess) {
                    if (state.messages.isEmpty) {
                      return const Center(
                        child: Text(
                          'لا توجد رسائل بعد',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16.w),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return _buildMessageBubble(message);
                      },
                    );
                  } else if (state is ChatFailure) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    // For RTL (Arabic): isMe should be on the LEFT, other on the RIGHT
    // This is the opposite of LTR languages
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        constraints: BoxConstraints(maxWidth: 280.w),
        decoration: BoxDecoration(
          color: message.isMe ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: message.isMe ? Radius.circular(16.r) : Radius.zero,
            bottomRight: message.isMe ? Radius.zero : Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: message.isMe ? Colors.white : Colors.black87,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('hh:mm a').format(message.createdAt),
                  style: TextStyle(
                    color: message.isMe ? Colors.white70 : Colors.black54,
                    fontSize: 10.sp,
                  ),
                ),
                if (message.isMe) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    message.isPending ? Icons.schedule : Icons.done_all,
                    size: 12.sp,
                    color: Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
                      : Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(context),
              ),
            ),
            SizedBox(width: 8.w),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white, size: 20.sp),
                    onPressed: () => _sendMessage(context),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    if (_controller.text.trim().isNotEmpty) {
      context.read<ChatCubit>().sendMessage(
        tripId: widget.tripId,
        content: _controller.text.trim(),
      );
      _controller.clear();
      _scrollToBottom();
    }
  }
}
