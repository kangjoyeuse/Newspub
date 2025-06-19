import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newspub/newsmodel.dart';

Future<List<NewsArticle>> fetchNewsArticles() async {
  final response = await http.get(
      Uri.parse('http://45.149.187.204:3000/api/news')
  );

  if(response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    final List articles = jsonBody['body']['data'];
    return articles.map((e) => NewsArticle.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}

Future<Map<String, dynamic>> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://45.149.187.204:3000/api/auth/login'),
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