import 'package:flutter/material.dart';
import 'package:job_portal_app/screens/common/forgot_password_screen.dart';
import 'package:job_portal_app/screens/common/home_wrapper.dart';
import 'package:job_portal_app/screens/common/login_screen.dart';
import 'package:job_portal_app/screens/common/register_screen.dart';
import 'package:job_portal_app/screens/recruiter/company_profile_screen.dart';
import 'package:job_portal_app/screens/recruiter/notification_screen.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSession.load();
  runApp(const JobPortalApp());
}

class JobPortalApp extends StatelessWidget {
  const JobPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    final isLoggedIn = UserSession.userId != null && UserSession.role != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeWrapper(),
        '/company_profile': (context) => const CompanyProfileScreen(),
        '/notification': (context) => const NotificationScreen(),
      },
    );
  }
}
