import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static int? _userId;
  static String? _role;
  static String? _email;

  // Lưu session
  static Future<void> save({
    required int userId,
    required String role,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
    await prefs.setString('role', role);
    await prefs.setString('email', email);

    // Đồng bộ vào biến static
    _userId = userId;
    _role = role;
    _email = email;
  }

  // Load session từ SharedPreferences (gọi ở app start hoặc sau login)
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');
    _role = prefs.getString('role');
    _email = prefs.getString('email');
  }

  // Getter sync
  static int? get userId => _userId;
  static String? get role => _role;
  static String? get email => _email;

  // Xóa session khi logout
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _userId = null;
    _role = null;
    _email = null;
  }
}