import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookmarkScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const BookmarkScreen({
    super.key,
    this.userData,
    required List<Map<String, dynamic>> localBookmarks,
  });

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<BookmarkItem> bookmarkedArticles = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('bookmarks') ?? [];
    setState(() {
      bookmarkedArticles =
          list.map((item) => BookmarkItem.fromJson(jsonDecode(item))).toList();
    });
  }

  Future<void> removeBookmark(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('bookmarks') ?? [];
    final item = jsonEncode(bookmarkedArticles[index].toJson());
    list.remove(item);
    await prefs.setStringList('bookmarks', list);
    setState(() {
      bookmarkedArticles.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Removed from bookmarks')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF475569)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Bookmarks',
          style: GoogleFonts.beVietnamPro(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body:
          bookmarkedArticles.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No bookmarks yet',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start bookmarking articles to see them here',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                itemCount: bookmarkedArticles.length,
                separatorBuilder:
                    (_, __) =>
                        const Divider(height: 0, color: Color(0xFFF1F5F9)),
                itemBuilder: (context, index) {
                  final article = bookmarkedArticles[index];
                  return BookmarkCard(
                    article: article,
                    onRemoveBookmark: () => removeBookmark(index),
                  );
                },
              ),
    );
  }
}

// Model bookmark
class BookmarkItem {
  final String imageUrl;
  final String title;
  final String description;
  final String category;

  BookmarkItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'imageUrl': imageUrl,
    'title': title,
    'description': description,
    'category': category,
  };

  factory BookmarkItem.fromJson(Map<String, dynamic> json) => BookmarkItem(
    imageUrl: json['imageUrl'],
    title: json['title'],
    description: json['description'],
    category: json['category'],
  );
}

// Widget kartu bookmark
class BookmarkCard extends StatelessWidget {
  final BookmarkItem article;
  final VoidCallback onRemoveBookmark;

  const BookmarkCard({
    super.key,
    required this.article,
    required this.onRemoveBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 72,
              height: 72,
              color: const Color(0xFFE2E8F0),
              child: Image.network(
                article.imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Teks artikel
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  article.description,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF475569),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  article.category,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          // Icon bookmark
          IconButton(
            icon: const Icon(Icons.bookmark, color: Color(0xFF207BF3)),
            onPressed: onRemoveBookmark,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
