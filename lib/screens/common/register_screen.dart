import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_app/services/auth_service.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? selectedRole;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
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
    final result = await AuthService().register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
      selectedRole!.toLowerCase(),
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
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text('Create a new account', style: textTheme.displayMedium),
              SizedBox(height: 44),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full name/ Company name",
                  labelStyle: textTheme.labelLarge,
                  suffixIcon: Icon(Icons.person_outline, color: AppColors.hint),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter name" : null,
              ),
              SizedBox(height: 32),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: textTheme.labelLarge,
                  suffixIcon: Icon(Icons.email_outlined, color: AppColors.hint),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter email";
                  }
                  // Simple email validation
                  if (!RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  ).hasMatch(value)) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

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

              // Role
              DropdownButtonFormField2<String>(
                isExpanded: true,
                value: selectedRole,
                items: ['Candidate', 'Recruiter']
                    .map(
                      (role) => DropdownMenuItem<String>(
                        value: role,
                        child: Text(role, style: textTheme.bodyLarge),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Role",
                  labelStyle: textTheme.labelLarge,
                ),
                dropdownStyleData: DropdownStyleData(
                  width: MediaQuery.of(context).size.width - 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  offset: Offset(0, -4),
                ),
                validator: (value) =>
                    value == null ? 'Please select role' : null,
              ),

              SizedBox(height: 32),

              // Register button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: handleRegister,
                  child: Text("Sign Up"),
                ),
              ),
              SizedBox(height: 32),

              // Sign up text
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Already have an account?", style: textTheme.bodyMedium),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      "Sign In",
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
      ),
    );
  }
}
