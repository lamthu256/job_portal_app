import 'package:flutter/material.dart';
import 'package:job_portal_app/services/auth_service.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  final int userId;

  const ResetPasswordScreen({super.key, required this.userId});

  @override
  State<ResetPasswordScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Confirmation password does not match')),
      );
      return;
    }

    // Goi AuthService
    final result = await AuthService().resetPassword(
      widget.userId,
      _passwordController.text,
    );

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
      Navigator.pushReplacementNamed(context, '/login');
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
        padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Center(
                child: Image.asset(
                  'assets/forgot_password.png',
                  width: 200,
                  height: 200,
                ),
              ),

              // Forgot Password
              Text('Reset Password', style: textTheme.displayMedium),
              SizedBox(height: 10),

              // Text
              Text(
                'Please enter your new password.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 36),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: textTheme.labelLarge,
                  suffixIcon: Icon(Icons.lock_outline, color: AppColors.hint),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter password" : null,
              ),
              SizedBox(height: 32),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: textTheme.labelLarge,
                  suffixIcon: Icon(Icons.lock_outline, color: AppColors.hint),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter confirm password" : null,
              ),
              SizedBox(height: 32),

              // Reset Password button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: handleRegister,
                  child: Text("Reset Password"),
                ),
              ),
              SizedBox(height: 32),

              // Back
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, '/forgot_password');
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
