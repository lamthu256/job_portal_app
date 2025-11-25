import 'package:flutter/material.dart';
import 'package:job_portal_app/screens/candidate/profile_screen.dart';
import 'package:job_portal_app/screens/recruiter/company_profile_screen.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/setting/setting_button.dart';

class SettingsScreen extends StatefulWidget {
  final String? avatarUrl;
  final String name;
  final VoidCallback onProfileUpdated;

  const SettingsScreen({
    super.key,
    this.avatarUrl,
    required this.name,
    required this.onProfileUpdated,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool emailNotif = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + Name
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserSession.role == 'candidate'
                          ? ProfileScreen(
                              onProfileUpdated: widget.onProfileUpdated,
                            )
                          : CompanyProfileScreen(
                              onProfileUpdated: widget.onProfileUpdated,
                            ),
                    ),
                  );
                },
                child: ClipOval(
                  child: Image(
                    image: widget.avatarUrl != ""
                        ? NetworkImage(widget.avatarUrl!)
                        : const AssetImage("assets/default_avatar.png")
                              as ImageProvider,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: textTheme.headlineLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    if (UserSession.email != null)
                      Text(UserSession.email!, style: textTheme.labelSmall),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 40),

          // Account
          SettingButton(
            leadingIcon: Icons.person_outline,
            label: "Profile",
            trailingIcon: Icons.arrow_forward_ios,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserSession.role == 'candidate'
                      ? ProfileScreen(onProfileUpdated: widget.onProfileUpdated)
                      : CompanyProfileScreen(
                          onProfileUpdated: widget.onProfileUpdated,
                        ),
                ),
              );
            },
          ),

          // Notifications
          Container(
            height: 55,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text("Notifications", style: textTheme.bodyLarge),
                Spacer(),
                Transform.scale(
                  alignment: Alignment.centerRight,
                  scale: 0.6,
                  child: Switch(
                    value: emailNotif,
                    onChanged: (val) => setState(() => emailNotif = val),
                    activeColor: AppColors.surface,
                    // màu của nút tròn
                    activeTrackColor: AppColors.primary,
                    // màu nền khi bật
                    inactiveThumbColor: AppColors.surface,
                    inactiveTrackColor: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),

          SettingButton(
            leadingIcon: Icons.lock_outline,
            label: "Privacy & Security",
            trailingIcon: Icons.arrow_forward_ios,
          ),
          SettingButton(
            leadingIcon: Icons.headphones_outlined,
            label: "Help and Support",
            trailingIcon: Icons.arrow_forward_ios,
          ),
          SettingButton(
            leadingIcon: Icons.info_outline,
            label: "About",
            trailingIcon: Icons.arrow_forward_ios,
          ),
          SettingButton(
            leadingIcon: null,
            label: "Delete account",
            trailingIcon: Icons.arrow_forward_ios,
          ),
          SettingButton(
            leadingIcon: null,
            label: "Log out",
            trailingIcon: Icons.arrow_forward_ios,
            onPressed: () {
              UserSession.clear();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
