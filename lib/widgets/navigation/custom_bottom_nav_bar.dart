import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final String? role;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    this.role,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(42),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10, // độ mờ của bóng
            offset: const Offset(0, -2), // đổ bóng lên
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(42)),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          showUnselectedLabels: false,
          onTap: onTap,
          items: (role == 'candidate')
              ? [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: "Search",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.work),
                    label: "Activity",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: "Settings",
                  ),
                ]
              : [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.work),
                    label: "Jobs",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assignment),
                    label: "Applications",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group),
                    label: "Candidates",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: "Settings",
                  ),
                ],
        ),
      ),
    );
  }
}
