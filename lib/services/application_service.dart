import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:job_portal_app/config/constants.dart';

class ApplicationService {
  Future<Map<String, dynamic>> getAppliedJobs(int candidateId) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}applications/get_applied_jobs.php',
    );
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'candidate_id': candidateId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> postApplication(
    int jobId,
    int candidateId,
    File resumeFile,
    String introduction,
  ) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}applications/post_application.php',
    );

    final request = http.MultipartRequest('POST', url);
    request.fields['job_id'] = jobId.toString();
    request.fields['candidate_id'] = candidateId.toString();
    request.files.add(
      await http.MultipartFile.fromPath('resume', resumeFile.path),
    );
    request.fields['introduction'] = introduction;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }

  Future<Map<String, dynamic>> checkApplication(
    int jobId,
    int candidateId,
  ) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}applications/check_application.php',
    );
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'job_id': jobId, 'candidate_id': candidateId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> getJobApplications(int jobId) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}applications/get_job_applications.php',
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'job_id': jobId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> getApplicationList(int userId) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}applications/get_application_list.php',
    );

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

  Future<Map<String, dynamic>> getApplication(int applicationId) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}applications/get_application.php',
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'application_id': applicationId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> updateStatusApplication(
    int applicationId,
    String status,
    String title,
    String companyName,
  ) async {
    final url = Uri.parse(
      "${AppConfig.baseUrl}applications/update_status_application.php",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'application_id': applicationId,
        'status': status,
        'title': title,
        'company_name': companyName,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }

  Future<Map<String, dynamic>> getCandidateApplications(
    int recruiterId,
    int candidateId,
  ) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}applications/get_candidate_applications.php',
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'recruiter_id': recruiterId,
        'candidate_id': candidateId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }
}
