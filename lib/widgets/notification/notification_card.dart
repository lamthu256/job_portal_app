import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String avatar, name, position, date, title;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.position,
    required this.date,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/candidate_detail');
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(avatar),
                ),
                SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + More icon
                      Row(
                        children: [
                          Expanded(
                            child: Text(name, style: textTheme.headlineSmall),
                          ),
                          Text(date, style: textTheme.bodySmall,)
                        ],
                      ),
                      Text(position, style: textTheme.bodyMedium),
                      Text(title, style: textTheme.labelSmall,)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
