import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:job_portal_app/services/notification_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class NotificationScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? initialNotifications;
  final VoidCallback? onNotificationsUpdated;

  const NotificationScreen({
    super.key,
    this.initialNotifications,
    this.onNotificationsUpdated,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() async {
    final userId = UserSession.userId;
    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    if (widget.initialNotifications != null &&
        widget.initialNotifications!.isNotEmpty) {
      setState(() {
        notifications = widget.initialNotifications!;
        isLoading = false;
      });
    } else {
      final result = await NotificationService().getNotificationList(userId);

      if (mounted) {
        setState(() {
          if (result['success']) {
            notifications = List<Map<String, dynamic>>.from(
              result['notifications'] ?? [],
            );
          }
          isLoading = false;
        });
      }
    }
  }

  void _markAllAsRead() async {
    final userId = UserSession.userId;
    if (userId == null) return;

    await NotificationService().markAllAsRead(userId);

    if (mounted) {
      _fetchNotifications();
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green.shade100;
      case 'rejected':
        return Colors.red.shade100;
      case 'interviewing':
        return Colors.blue.shade100;
      case 'pending':
      default:
        return Colors.orange.shade100;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green.shade800;
      case 'rejected':
        return Colors.red.shade800;
      case 'interviewing':
        return Colors.blue.shade800;
      case 'pending':
      default:
        return Colors.orange.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Icon(Icons.arrow_back_ios_new_outlined, size: 18),
                ),
                SizedBox(width: 8),
                Text("Notifications", style: textTheme.headlineMedium),
                Spacer(),
                GestureDetector(
                  onTap: _markAllAsRead,
                  child: Text(
                    'Mark all read',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            // Notifications List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _fetchNotifications();
                  await Future.delayed(Duration(seconds: 1));
                },
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: [
                    if (notifications.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            "No notifications",
                            style: textTheme.bodyLarge!.copyWith(
                              color: AppColors.hint,
                            ),
                          ),
                        ),
                      )
                    else
                      ...notifications.map((notif) {
                        Map<String, dynamic> message = {};
                        try {
                          message = jsonDecode(notif['message'] ?? '{}');
                        } catch (e) {
                          message = {};
                        }

                        return GestureDetector(
                          onTap: () {
                            if (notif['is_read'] == 0) {
                              NotificationService().markAsRead(notif['id']);
                            }
                            Navigator.pop(context, true);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: notif['is_read'] == 1
                                  ? AppColors.hint.withOpacity(0.2)
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['title'] ?? '',
                                  style: textTheme.headlineSmall!.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  message['companyName'] ?? '',
                                  style: textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      notif['created_at'],
                                      style: textTheme.bodyMedium,
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                          message['status'] ?? '',
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        message['status'] ?? '',
                                        style: textTheme.labelSmall!.copyWith(
                                          color: getStatusTextColor(
                                            message['status'] ?? '',
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
