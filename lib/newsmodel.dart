class NewsArticle {
  final String id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String featuredImageUrl;
  final String category;
  final List<String> tags;
  final bool isPublished;
  final String publishedAt;
  final int viewCount;
  final String createdAt;
  final String updatedAt;
  final String authorName;
  final String? authorBio;
  final String? authorAvatar;

  NewsArticle({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    required this.featuredImageUrl,
    required this.category,
    required this.tags,
    required this.isPublished,
    required this.publishedAt,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
    required this.authorName,
    this.authorBio,
    this.authorAvatar,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      featuredImageUrl: json['featured_image_url'] ?? '',
      category: json['category'] ?? '',
      tags: json['tags'] != null
          ? List<String>.from(json['tags'].map((tag) => tag.toString()))
          : [],
      isPublished: json['is_published'] ?? false,
      publishedAt: json['published_at'] ?? '',
      viewCount: json['view_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      authorName: json['author_name'] ?? '',
      authorBio: json['author_bio'],
      authorAvatar: json['author_avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'summary': summary,
      'content': content,
      'featured_image_url': featuredImageUrl,
      'category': category,
      'tags': tags,
      'is_published': isPublished,
      'published_at': publishedAt,
      'view_count': viewCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'author_name': authorName,
      'author_bio': authorBio,
      'author_avatar': authorAvatar,
    };
  }

  // Helper method to get formatted publish date
  String get formattedPublishDate {
    try {
      final dateTime = DateTime.parse(publishedAt);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } catch (e) {
      return publishedAt.split('T')[0]; // Fallback
    }
  }

  // Helper method to get status text
  String get statusText => isPublished ? 'Published' : 'Draft';

  // Copy with method for updating article
  NewsArticle copyWith({
    String? id,
    String? title,
    String? slug,
    String? summary,
    String? content,
    String? featuredImageUrl,
    String? category,
    List<String>? tags,
    bool? isPublished,
    String? publishedAt,
    int? viewCount,
    String? createdAt,
    String? updatedAt,
    String? authorName,
    String? authorBio,
    String? authorAvatar,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      featuredImageUrl: featuredImageUrl ?? this.featuredImageUrl,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authorName: authorName ?? this.authorName,
      authorBio: authorBio ?? this.authorBio,
      authorAvatar: authorAvatar ?? this.authorAvatar,
    );
  }
}