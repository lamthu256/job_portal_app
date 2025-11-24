import 'package:flutter/material.dart';
import 'package:job_portal_app/screens/common/reset_password_screen.dart';
import 'package:job_portal_app/services/auth_service.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    // Goi AuthService
    final result = await AuthService().checkEmail(_emailController.text.trim());

    if (!mounted) return;

    // Hien thi ket qua
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success']
            ? AppColors.success
            : AppColors.error,
      ),
    );

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(userId: result['user_id']),
        ),
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              Image.asset(
                'assets/forgot_password.png',
                width: 200,
                height: 200,
              ),

              // Forgot Password
              Text('Forgot Password?', style: textTheme.displayMedium),
              SizedBox(height: 28),

              // Text
              Text(
                'Please enter your registered Email to reset your password.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 28),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: textTheme.labelLarge,
                  suffixIcon: Icon(Icons.email_outlined, color: AppColors.hint),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter email" : null,
              ),
              SizedBox(height: 24),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    "Try another way",
                    style: textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Send button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: handleForgotPassword,
                  child: Text("Send"),
                ),
              ),
              SizedBox(height: 40),

              // Back
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.arrow_back, size: 20),
                    SizedBox(width: 2),
                    Text('Back', style: textTheme.headlineMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
