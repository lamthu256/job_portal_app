import 'package:flutter/material.dart';
import 'package:job_portal_app/screens/candidate/candidate_screen.dart';
import 'package:job_portal_app/screens/recruiter/recruiter_screen.dart';
import 'package:job_portal_app/services/user_session.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final role = UserSession.role;

    if (role == 'candidate') {
      return const CandidateScreen();
    } else if (role == 'recruiter') {
      return const RecruiterScreen();
    } else {
      // Fallback to login if role is not recognized
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
