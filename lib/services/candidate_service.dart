import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job_portal_app/config/constants.dart';

class CandidateService {
  Future<Map<String, dynamic>> getCandidate(int userId) async {
    final url = Uri.parse('${AppConfig.baseUrl}candidates/get_candidate.php');

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

  Future<Map<String, dynamic>> updateCandidate(Map<String, dynamic> data) async {
    final url = Uri.parse('${AppConfig.baseUrl}candidates/update_candidate.php');

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

  Future<Map<String, dynamic>> getCandidateList(int userId) async {
    final url = Uri.parse('${AppConfig.baseUrl}candidates/get_candidate_list.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }
}
