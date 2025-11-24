import 'package:flutter/material.dart';
import 'package:job_portal_app/services/review_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class ReviewSheet extends StatefulWidget {
  final int jobId;

  const ReviewSheet({super.key, required this.jobId});

  @override
  State<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<ReviewSheet> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  int rating = 0;

  void postReview() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = UserSession.userId;

    if (userId != null) {
      final result = await ReviewService().postReview(
        userId,
        widget.jobId,
        rating,
        _contentController.text.trim(),
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
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("Give a review", style: textTheme.headlineMedium),
              ),
              const SizedBox(height: 16),

              // Star Rating
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                      child: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        size: 32,
                        color: Colors.amber,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),

              // Detail Review
              Text("Detail Review", style: textTheme.titleLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: "Type here",
                  hintStyle: textTheme.labelSmall,
                ),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? "Please enter content" : null,
              ),
              SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: postReview,
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
