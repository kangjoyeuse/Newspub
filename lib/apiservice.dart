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
