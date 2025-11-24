import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job_portal_app/config/constants.dart';
import 'package:open_file/open_file.dart';

class UserService {
  Future<Map<String, dynamic>> uploadAvatar(
    int userId,
    String role,
    File avatarFile,
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}users/upload_avatar.php');

    final request = http.MultipartRequest('POST', url);
    request.fields['user_id'] = userId.toString();
    request.fields['role'] = role;
    request.files.add(
      await http.MultipartFile.fromPath('avatar', avatarFile.path),
    );
    // print(avatarFile.toString());

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Error'};
    }
  }

  Future<void> downloadAndOpenFile(String url, String fileName) async {
    try {
      // final dir = await getApplicationDocumentsDirectory();
      // print('Downloading file from $dir');
      final savePath = '/Users/tranthilamthu/Downloads/$fileName';
      print('Downloading file from $url');
      final dio = Dio();
      await dio.download(url, savePath);
      print('File saved to: $savePath');
      final result = await OpenFile.open(savePath);
      print('Open result: ${result.message}');
    } catch (e) {
      print('Download failed: $e');
    }
  }
}
