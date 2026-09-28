import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ==============================
  // BASE URL
  // ==============================

  static const String baseUrl =
      'http://10.213.40.196:8000';

  // ==============================
  // REGISTER
  // ==============================

  static Future<Map<String, dynamic>> register(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Registration failed: ${response.body}',
    );
  }

  // ==============================
  // LOGIN
  // ==============================

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Login failed: ${response.body}',
    );
  }

  // ==============================
  // BASIC PROFILE SETUP
  // ==============================

  static Future<Map<String, dynamic>> setupProfile({
    required String email,
    required String name,
    required String dob,
    required String age,
    required String gender,
    required String maritalStatus,
    required String educationLevel,
    required String currentlyStudying,
    required String course,
    required String occupation,
    required String annualFamilyIncome,
    required String state,
    required String district,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/profile/setup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'name': name,
        'dob': dob,
        'age': int.tryParse(age) ?? 0,
        'gender': gender,
        'marital_status': maritalStatus,
        'education_level': educationLevel,
        'currently_studying': currentlyStudying,
        'course': course,
        'occupation': occupation,
        'annual_family_income':
            double.tryParse(annualFamilyIncome) ?? 0,
        'state': state,
        'district': district,
      }),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Profile setup failed: ${response.body}',
    );
  }

  // ==============================
  // GET BASIC PROFILE
  // ==============================

  static Future<Map<String, dynamic>> getProfile(
    String email,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/$email'),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to load profile: ${response.body}',
    );
  }

  // ==============================
  // ADDITIONAL PROFILE SETUP
  // ==============================

  static Future<Map<String, dynamic>>
      saveAdditionalProfile({
    required String email,
    required int selectedCategoryId,
    required Map<String, dynamic> additionalData,
  }) async {
    final Map<String, dynamic> body = {
      'email': email,
      'selected_category_id': selectedCategoryId,
      ...additionalData,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/profile/additional'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Additional profile setup failed: ${response.body}',
    );
  }

  // ==============================
  // RECOMMENDATIONS
  // ==============================

  static Future<List<dynamic>> getRecommendations(
    String email,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/recommendation/$email',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return List<dynamic>.from(
        data['recommendations'] ?? [],
      );
    }

    throw Exception(
      'Failed to load recommendations: ${response.body}',
    );
  }

  // ==============================
  // GET ALL SCHEMES
  // ==============================

  static Future<List<dynamic>> getAllSchemes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/schemes/'),
    );

    if (response.statusCode == 200) {
      return List<dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to load schemes: ${response.body}',
    );
  }

  // ==============================
  // GET SCHEMES BY CATEGORY
  // ==============================

  static Future<List<dynamic>> getSchemesByCategory(
    int categoryId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/schemes/category/$categoryId',
      ),
    );

    if (response.statusCode == 200) {
      return List<dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to load category schemes: ${response.body}',
    );
  }

  // ==============================
  // SAVE SCHEME
  // ==============================

  static Future<Map<String, dynamic>> saveScheme(
    String email,
    int schemeId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/saved/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'scheme_id': schemeId,
      }),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to save scheme: ${response.body}',
    );
  }

  // ==============================
  // GET SAVED SCHEMES
  // ==============================

  static Future<List<dynamic>> getSavedSchemes(
    String email,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/saved/$email'),
    );

    if (response.statusCode == 200) {
      return List<dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to load saved schemes: ${response.body}',
    );
  }

  // ==============================
  // REMOVE SAVED SCHEME
  // ==============================

  static Future<Map<String, dynamic>> unsaveScheme(
    String email,
    int schemeId,
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/saved/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'scheme_id': schemeId,
      }),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to remove saved scheme: ${response.body}',
    );
  }

  // ==============================
  // CHATBOT
  // ==============================

  static Future<Map<String, dynamic>> sendChatMessage(
    String message,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chatbot/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to get chatbot response: ${response.body}',
    );
  }
}