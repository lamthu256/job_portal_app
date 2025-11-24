import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job_portal_app/config/constants.dart';
import 'package:job_portal_app/models/recruiter.dart';

class RecruiterService {

  Future<List<Recruiter>> getAllRecruiters() async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}recruiters/get_all_recruiters.php',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        return (result['data'] as List)
            .map((recruiter) => Recruiter.fromJson(recruiter))
            .toList();
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> getRecruiter(int userId) async {
    final url = Uri.parse('${AppConfig.baseUrl}recruiters/get_recruiter.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }

  Future<Map<String, dynamic>> updateRecruiter(
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}recruiters/update_recruiter.php',
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }
}
