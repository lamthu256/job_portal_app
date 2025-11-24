import 'package:flutter/material.dart';
import 'package:job_portal_app/services/review_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/job_detail/review/review_card.dart';
import 'package:job_portal_app/widgets/job_detail/review/review_sheet.dart';

class ReviewTab extends StatefulWidget {
  final int jobId;

  const ReviewTab({
    super.key,
    required this.jobId,
  });

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  List<dynamic> reviews = [];
  int totalReviews = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReviews();
  }

  void fetchReviews() async {
    final role = UserSession.role;
    final result = await ReviewService().getReviews(widget.jobId);

    if (result['success']) {
      setState(() {
        reviews = result['reviews'].where((review) {
          if (role == 'recruiter' && review['status'] != 'deleted') return true;
          return review['status'] == 'sent';
        }).toList();
        totalReviews = result['total_reviews'];
      });
    }
  }

  void updateStatus(int reviewId, String status) async {
    final result = await ReviewService().updateStatus(reviewId, status);

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
      fetchReviews();
    }
  }

  void openReviewSheet() async {
    final result = await showModalBottomSheet(
      backgroundColor: AppColors.background,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ReviewSheet(jobId: widget.jobId),
    );

    if (result == true) {
      fetchReviews();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final role = UserSession.role;

    return SingleChildScrollView(
      child: Column(
        children: [
          if (role != "recruiter") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "$totalReviews",
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Text('Reviews', style: textTheme.bodyLarge),
                Spacer(),
                GestureDetector(
                  onTap: openReviewSheet,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.surface, size: 18),
                        SizedBox(width: 2),
                        Text(
                          'Add review',
                          style: TextStyle(color: AppColors.surface),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
          ],
          Column(
            children: reviews.map((review) {
              return ReviewCard(
                avatar:
                    (review['avatar_url'] != null &&
                        review['avatar_url'].toString().isNotEmpty)
                    ? NetworkImage(review['avatar_url'].toString())
                    : AssetImage("assets/default_avatar.png"),
                name: review['full_name'],
                rating: review['rating'],
                content: review['content'],
                status: review['status'],
                createdAt: review['created_at'],
                onDelete: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Confirm Delete"),
                      content: Text(
                        "Are you sure you want to delete this review?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            updateStatus(review['id'], 'deleted');
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
