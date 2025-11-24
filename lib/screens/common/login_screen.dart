import 'package:flutter/material.dart';
import 'package:job_portal_app/screens/candidate/candidate_screen.dart';
import 'package:job_portal_app/screens/recruiter/recruiter_screen.dart';
import 'package:job_portal_app/services/auth_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await AuthService().login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success']
            ? AppColors.success
            : AppColors.error,
      ),
    );

    if (result['success']) {
      final userId = int.parse(result['user']['id'].toString());
      final role = result['user']['role'];
      final email = result['user']['email'];
      await UserSession.save(
        userId: userId,
        role: role,
        email: email,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        role == 'candidate'
            ? MaterialPageRoute(builder: (_) => CandidateScreen())
            : MaterialPageRoute(builder: (_) => RecruiterScreen()),
      );
    }
  }

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
              Icon(
                Icons.align_vertical_center_rounded,
                color: AppColors.primary,
              ),
              SizedBox(width: 6),
              Text('My Logo', style: textTheme.displaySmall),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text('Welcome', style: textTheme.displayLarge),
            SizedBox(height: 6),

            Text('Login to your account', style: textTheme.displayMedium),
            SizedBox(height: 44),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: textTheme.labelLarge,
                      suffixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.hint,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter email" : null,
                  ),
                  SizedBox(height: 32),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: textTheme.labelLarge,
                      suffixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.hint,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter password" : null,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => handleLogin(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Remember + Forgot
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (_) {},
                  shape: CircleBorder(),
                  visualDensity: VisualDensity.compact,
                ),
                Text("Remember me", style: textTheme.bodyMedium),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/forgot_password');
                  },
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(color: AppColors.hint, fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Login button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: handleLogin,
                child: Text("Log In"),
              ),
            ),
            SizedBox(height: 32),

            // Sign up text
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Don't have an account?", style: textTheme.bodyMedium),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: Text(
                    "Sign Up",
                    style: textTheme.titleMedium!.copyWith(
                      color: AppColors.primary,
                    ),
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
