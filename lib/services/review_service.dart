import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_portal_app/config/constants.dart';

class ReviewService {
  Future<Map<String, dynamic>> postReview(
    int userId,
    int jobId,
    int rating,
    String content,
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}reviews/post_review.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'user_id': userId,
        'job_id': jobId,
        'rating': rating,
        'content': content,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }

  Future<Map<String, dynamic>> getReviews(int jobId) async {
    final url = Uri.parse("${AppConfig.baseUrl}reviews/get_reviews.php");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'job_id': jobId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }

  Future<Map<String, dynamic>> updateStatus(int reviewId, String status) async {
    final url = Uri.parse("${AppConfig.baseUrl}reviews/update_status_review.php");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'review_id': reviewId, 'status': status}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }
}
