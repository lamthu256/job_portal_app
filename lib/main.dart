import 'package:flutter/material.dart';
import 'package:job_portal_app/screens/common/forgot_password_screen.dart';
import 'package:job_portal_app/screens/common/login_screen.dart';
import 'package:job_portal_app/screens/common/register_screen.dart';
import 'package:job_portal_app/screens/recruiter/company_profile_screen.dart';
import 'package:job_portal_app/screens/recruiter/notification_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const JobPortalApp());
}

class JobPortalApp extends StatelessWidget {
  const JobPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/company_profile': (context) => const CompanyProfileScreen(),
        '/notification': (context) => const NotificationScreen(),
        // '/candidate': (context) => const CandidateScreen(),
        // '/recruiter': (context) => const RecruiterScreen(),
        // '/apply_form': (context) => const ApplyFormScreen(),
        // '/profile': (context) => const ProfileScreen(),
        // '/edit_profile': (context) => const EditProfileScreen(),
        // '/setting': (context) => const SettingsScreen(),
        // '/job_detail': (context) => const JobDetailScreen(),
        // '/posted_job_detail': (context) => const PostedJobDetailScreen(),
        // '/candidate_detail': (context) => const CandidateDetailScreen(),
      },
    );
  }
}