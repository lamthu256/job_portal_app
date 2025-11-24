import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_portal_app/config/constants.dart';
import 'package:job_portal_app/models/job.dart';

class JobService {
  Future<Map<String, dynamic>> getFeaturedJobs(int userId) async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/get_featured_jobs.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success']) {
        final jobList = (data['data'] as List)
            .map((jobJson) => Job.fromJson(jobJson))
            .toList();

        return {'success': true, 'data': jobList};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Error'};
      }
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }

  Future<Map<String, dynamic>> getLatestJob() async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/get_latest_jobs.php');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success']) {
        final jobList = (data['data'] as List)
            .map((jobJson) => Job.fromJson(jobJson))
            .toList();

        return {'success': true, 'data': jobList};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Error'};
      }
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }

  Future<Map<String, dynamic>> getSavedJobs(int userId) async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/get_saved_jobs.php');

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

  Future<Map<String, dynamic>> getRecruiterJobs(
      int userId,
      int recruiterId,
      ) async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/get_recruiter_jobs.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'user_id': userId, 'recruiter_id': recruiterId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> getDetailJob(int userId, int jobId) async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/get_detail_job.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'user_id': userId, 'job_id': jobId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> getFilterOptions() async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/get_filter_options.php');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Server error'};
    }
  }

  Future<Map<String, dynamic>> searchJobs({
    required int userId,
    String? keyword,
    String? companyName,
    String? location,
    int? fieldId,
    String? jobType,
    String? workplaceType,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/search_jobs.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'user_id': userId,
        'keyword': keyword ?? '',
        'company_name': companyName ?? '',
        'location': location ?? '',
        'field_id': fieldId ?? '',
        'job_type': jobType ?? '',
        'workplace_type': workplaceType ?? '',
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> getJobList(int userId, String? jobStatus) async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/get_job_list.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'user_id': userId,
        if (jobStatus != null && jobStatus.isNotEmpty) 'job_status': jobStatus,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> createJob(
    int recruiterId,
    String title,
    String salary,
    String jobType,
    String workplaceType,
    String experience,
    int vacancyCount,
    int fieldId,
    String jobDescription,
    String requirements,
    String interest,
    String workLocation,
    String workingTime,
    String deadline,
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/create_job.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'recruiter_id': recruiterId,
        'title': title,
        'salary': salary,
        'job_type': jobType,
        'workplace_type': workplaceType,
        'experience': experience,
        'vacancy_count': vacancyCount,
        'field_id': fieldId,
        'job_description': jobDescription,
        'requirements': requirements,
        'interest': interest,
        'work_location': workLocation,
        'working_time': workingTime,
        'deadline': deadline,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }

  Future<Map<String, dynamic>> updateJob(
    int jobId,
    int recruiterId,
    String title,
    String salary,
    String jobType,
    String workplaceType,
    String experience,
    int vacancyCount,
    int fieldId,
    String jobDescription,
    String requirements,
    String interest,
    String workLocation,
    String workingTime,
    String deadline,
    String jobStatus,
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/update_job.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'job_id': jobId,
        'recruiter_id': recruiterId,
        'title': title,
        'salary': salary,
        'job_type': jobType,
        'workplace_type': workplaceType,
        'experience': experience,
        'vacancy_count': vacancyCount,
        'field_id': fieldId,
        'job_description': jobDescription,
        'requirements': requirements,
        'interest': interest,
        'work_location': workLocation,
        'working_time': workingTime,
        'deadline': deadline,
        'job_status': jobStatus,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }

  Future<Map<String, dynamic>> deleteJob(int jobId, int recruiterId) async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/delete_job.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'job_id': jobId, 'recruiter_id': recruiterId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> toggleSaveJob(int userId, int jobId) async {
    final url = Uri.parse('${AppConfig.baseUrl}jobs/toggle_job_saved.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'job_id': jobId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }
}
