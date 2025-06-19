class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String featuredImageUrl;
  final String category;
  final String authorName;

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.featuredImageUrl,
    required this.category,
    required this.authorName,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
        id: json['id'],
        title: json['title'],
        summary: json['summary'],
        featuredImageUrl: json['featured_image_url'],
        category: json['category'],
        authorName: json['author_name']
    );
  }
}