import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConfig {
  static const String baseUrl = 'http://localhost:5000/api';

  // Function to create a share link
  static Future<String?> createShareLink(String docId, String permission, int expiresIn) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/documents/share/$docId'), // Fixed: added /documents
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'permission': permission,
          'expiresIn': expiresIn,
        }),
      );

      print('Share link response status: ${response.statusCode}');
      print('Share link response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['shareUrl'];
      } else {
        print('Error creating share link: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception creating share link: $e');
      return null;
    }
  }

  // Get shared document by token
  static Future<Map<String, dynamic>?> getSharedDocument(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/documents/share/$token'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Get shared document response: ${response.statusCode}');
      print('Get shared document body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        print('Share link not found or invalid');
        return null;
      } else if (response.statusCode == 403) {
        print('Share link expired');
        return null;
      } else {
        print('Error getting shared document: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception getting shared document: $e');
      return null;
    }
  }

  // Share document with a specific email
  static Future<bool> shareDocumentWithEmail(
      String docId, String email, String permission) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/documents/share-email/$docId'), // Fixed: added /documents and /$docId
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'permission': permission,
        }),
      );

      print('Share with email response: ${response.statusCode}');
      print('Share with email body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Exception sharing with email: $e');
      return false;
    }
  }

  // Create a new document
  static Future<Map<String, dynamic>?> createDocument(int userId, String title, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/documents/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'title': title,
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Exception creating document: $e');
      return null;
    }
  }

  // Get document by ID
  static Future<Map<String, dynamic>?> getDocument(String docId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/documents/$docId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Exception getting document: $e');
      return null;
    }
  }

  // Get all documents for a user
  static Future<List<dynamic>?> getUserDocuments(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/documents/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Exception getting user documents: $e');
      return null;
    }
  }

  // Update/save document
  static Future<bool> saveDocument(String docId, String title, String content) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/documents/save/$docId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'content': content,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Exception saving document: $e');
      return false;
    }
  }

  // Delete document
  static Future<bool> deleteDocument(String docId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/documents/delete/$docId'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Exception deleting document: $e');
      return false;
    }
  }
}