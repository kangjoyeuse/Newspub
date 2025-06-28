import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newspub/screen/bookmark_screen.dart';
import 'package:newspub/screen/login_screen.dart';
import 'package:newspub/screen/profile_screen.dart';
import 'package:newspub/screen/detail_screen.dart';
import '../apiservice.dart';
import '../newsmodel.dart';

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  State<NewsHomeScreen> createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? userData;
  List<String> bookmarkedIds = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarkedIds();
  }

  Future<void> _loadBookmarkedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList('bookmarks') ?? [];
    setState(() {
      bookmarkedIds = existing.map((encoded) {
        final data = jsonDecode(encoded);
        return data['id'] ?? '';
      }).where((id) => id.isNotEmpty).toList().cast<String>();
    });
  }

  void showLoginPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please login to access your profile'),
        action: SnackBarAction(
          label: 'Login',
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            if (result != null && result is Map<String, dynamic>) {
              setState(() => userData = result);
            }
          },
        ),
      ),
    );
  }

  Future<void> toggleBookmark(NewsArticle article) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList('bookmarks') ?? [];

    final encoded = jsonEncode({
      'id': article.id,
      'imageUrl': article.featuredImageUrl,
      'title': article.title,
      'description': article.summary,
      'category': article.category,
    });

    final isBookmarked = existing.any((item) {
      final data = jsonDecode(item);
      return data['id'] == article.id;
    });

    if (isBookmarked) {
      existing.removeWhere((item) {
        final data = jsonDecode(item);
        return data['id'] == article.id;
      });
      setState(() {
        bookmarkedIds.remove(article.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel dihapus dari bookmark')),
      );
    } else {
      existing.add(encoded);
      setState(() {
        bookmarkedIds.add(article.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel ditambahkan ke bookmark')),
      );
    }

    await prefs.setStringList('bookmarks', existing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[500]),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          userData == null
              ? TextButton.icon(
            icon: const Icon(Icons.login, color: Color(0xFF3B82F6)),
            label: const Text(
              'Login',
              style: TextStyle(
                color: Color(0xFF3B82F6),
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
              if (result != null && result is Map<String, dynamic>) {
                setState(() => userData = result);
              }
            },
          )
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                  userData!['author']['avatarUrl'] != null
                      ? NetworkImage(userData!['author']['avatarUrl'])
                      : null,
                  backgroundColor: Colors.blue,
                  child:
                  userData!['author']['avatarUrl'] == null
                      ? Text(
                    userData!['author']['firstName'][0],
                    style: const TextStyle(color: Colors.white),
                  )
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  '${userData!['author']['firstName']} ${userData!['author']['lastName']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<NewsArticle>>(
            future: fetchNewsArticles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No news found.'));
              }

              final latestNews = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top News',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        latestNews.length >= 3 ? 3 : latestNews.length,
                            (index) => TopNewsCard(
                          article: latestNews[index],
                          isBookmarked: bookmarkedIds.contains(latestNews[index].id),
                          onBookmarkToggle: () => toggleBookmark(latestNews[index]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Latest News',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: latestNews.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final news = latestNews[index];
                      return LatestNewsCard(
                        article: news,
                        isBookmarked: bookmarkedIds.contains(news.id),
                        onBookmarkToggle: () => toggleBookmark(news),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          if (userData != null)
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BookmarkScreen(localBookmarks: []),
              ),
            ).then((_) {
              // Refresh bookmark state after returning from BookmarkScreen
              _loadBookmarkedIds();
            });
          } else if (index == 2 && userData != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(userData: userData!),
              ),
            ).then((result) {
              if (result != null && result['logout'] == true) {
                setState(() {
                  userData = null;
                  _selectedIndex = 0;
                });
              }
            });
          } else {
            setState(() => _selectedIndex = index);
          }
        },
      ),
    );
  }
}

// Kartu vertikal utama dengan icon bookmark
class LatestNewsCard extends StatelessWidget {
  final NewsArticle article;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const LatestNewsCard({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(article: article),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.featuredImageUrl,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                  const Icon(Icons.image_not_supported, size: 48),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article.category,
                          style: const TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: onBookmarkToggle,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: isBookmarked ? Colors.blue : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Kartu horizontal Top News dengan icon bookmark
class TopNewsCard extends StatelessWidget {
  final NewsArticle article;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const TopNewsCard({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 160,
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(article: article),
              ),
            );
          },
          child: Stack(
            children: [
              Image.network(
                article.featuredImageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                const Icon(Icons.image_not_supported, size: 48),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onBookmarkToggle,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? Colors.yellow : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}