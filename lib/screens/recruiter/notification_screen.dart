import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/notification/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                  Navigator.pushNamed(context, '/recruiter');
                },
                child: Icon(Icons.arrow_back_ios_new_outlined, size: 18),
              ),
              SizedBox(width: 8),
              Text("Notification", style: textTheme.headlineMedium),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent", style: textTheme.headlineSmall),
                Spacer(),
                Text("Mark all as read", style: textTheme.bodySmall!.copyWith(color: AppColors.primary)),
              ],
            ),
            SizedBox(height: 10,),
            NotificationCard(
              avatar: "assets/avatar.png",
              name: "Alex Thomas",
              position: "UI Designer",
              date: "Jul 18, 2025",
              title: "Applied for UI/UX Designer",
            ),
            NotificationCard(
              avatar: "assets/avatar.png",
              name: "Emma Watson",
              position: "UI Designer",
              date: "Jul 18, 2025",
              title: "Applied for UI/UX Designer",
            ),
            NotificationCard(
              avatar: "assets/avatar.png",
              name: "Alex Thomas",
              position: "UI Designer",
              date: "Jul 18, 2025",
              title: "Applied for UI/UX Designer",
            ),
            NotificationCard(
              avatar: "assets/avatar.png",
              name: "Emma Watson",
              position: "UI Designer",
              date: "Jul 18, 2025",
              title: "Applied for UI/UX Designer",
            ),
          ],
        ),
      ),
    );
  }
}

