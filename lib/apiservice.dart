import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newspub/newsmodel.dart';

// Base URL constant
const String baseUrl = 'http://45.149.187.204:3000';

Future<List<NewsArticle>> fetchNewsArticles() async {
  final response = await http.get(
      Uri.parse('$baseUrl/api/news')
  );

  if(response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    final List articles = jsonBody['body']['data'];
    return articles.map((e) => NewsArticle.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}

// Fetch articles by author (for profile screen)
Future<List<NewsArticle>> fetchAuthorArticles(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/author/news'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    final List articles = jsonBody['body']['data'];
    return articles.map((e) => NewsArticle.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load author articles');
  }
}

// Create new article
Future<Map<String, dynamic>> createArticle({
  required String token,
  required String title,
  required String summary,
  required String content,
  required String featuredImageUrl,
  required String category,
  required List<String> tags,
  required bool isPublished,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/author/news'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'title': title,
      'summary': summary,
      'content': content,
      'featuredImageUrl': featuredImageUrl,
      'category': category,
      'tags': tags,
      'isPublished': isPublished,
    }),
  );

  final jsonBody = json.decode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    return {
      'success': true,
      'data': jsonBody['body']['data'],
      'message': jsonBody['body']['message'],
    };
  } else {
    return {
      'success': false,
      'message': jsonBody['body']['message'] ?? 'Failed to create article',
    };
  }
}

// Update existing article
Future<Map<String, dynamic>> updateArticle({
  required String token,
  required String articleId,
  required String title,
  required String summary,
  required String content,
  required String featuredImageUrl,
  required String category,
  required List<String> tags,
  required bool isPublished,
}) async {
  final response = await http.put(
    Uri.parse('$baseUrl/api/author/news/$articleId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'title': title,
      'summary': summary,
      'content': content,
      'featuredImageUrl': featuredImageUrl,
      'category': category,
      'tags': tags,
      'isPublished': isPublished,
    }),
  );

  final jsonBody = json.decode(response.body);

  if (response.statusCode == 200) {
    return {
      'success': true,
      'data': jsonBody['body']['data'],
      'message': jsonBody['body']['message'],
    };
  } else {
    return {
      'success': false,
      'message': jsonBody['body']['message'] ?? 'Failed to update article',
    };
  }
}

// Delete article
Future<Map<String, dynamic>> deleteArticle({
  required String token,
  required String articleId,
}) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/api/author/news/$articleId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  final jsonBody = json.decode(response.body);

  if (response.statusCode == 200) {
    return {
      'success': true,
      'message': jsonBody['body']['message'],
    };
  } else {
    return {
      'success': false,
      'message': jsonBody['body']['message'] ?? 'Failed to delete article',
    };
  }
}

Future<Map<String, dynamic>> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/login'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  final jsonBody = json.decode(response.body);

  if (response.statusCode == 200 && jsonBody['body']['success'] == true) {
    return {
      'success': true,
      'token': jsonBody['body']['data']['token'],
      'author': jsonBody['body']['data']['author'],
      'message': jsonBody['body']['message'],
    };
  } else {
    return {
      'success': false,
      'message': jsonBody['body']['message'] ?? 'Login failed',
    };
  }
}