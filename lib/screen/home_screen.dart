import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newspub/screen/bookmark_screen.dart';
import 'package:newspub/screen/login_screen.dart';

import '../apiservice.dart';
import '../newsmodel.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Home',
      theme: ThemeData(
        // Mengatur font default untuk seluruh aplikasi
        textTheme: GoogleFonts.beVietnamProTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // bg-slate-50
        useMaterial3: true,
      ),
      home: const NewsHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  State<NewsHomeScreen> createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? userData;

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
              setState(() {
                userData = result;
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0, // shadow-sm
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

                  // Check if result contains user data from login screen
                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      userData = result;
                    });
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeaturedSection(),
            _buildLatestNewsSection(),
            // Padding untuk menghindari tumpang tindih dengan BottomNavigationBar
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmark',
          ),
          // Hanya tampilkan item Profile jika user sudah login
          if (userData != null)
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[500],
        onTap: (index) {
          if (index == 1) {
            // Navigate to bookmark screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookmarkScreen()),
            );
          } else if (index == 2 && userData != null) {
            // Handle profile navigation ketika user sudah login
            setState(() {
              _selectedIndex = index;
            });
            // TODO: Navigate to profile screen
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
    );
  }

  // Widget untuk section berita utama (horizontal scroll)
  Widget _buildFeaturedSection() {
    // Data dummy untuk artikel
    final featuredArticles = [
      {
        "image":
            "https://lh3.googleusercontent.com/aida-public/AB6AXuC6t_1F-8In5p9aoUyLLUYUTFGz4BoAwEPEfNsFB5s0vcpZ7ZUKDIV3wGHOQh2dLKCHpPAm-_enC1UXJMGjYjmMAWDQGe_QPhxevYfwyVzSyS_NUclrGTdCWW0SUPhQMryRu8tI2IdR2dURuk1iucqscbXn4kfgA9LUAzTVPAoGJuekEgCRT-Cesapni2wND6ynnJOeptB6PXgIXZue5_TZSeeRY41s13CD3rT71r6SRh0b6qaxLBgV_CKKJEWETn8FUcPOeyDv2KY",
        "category": "Technology",
        "title": "Tech Giants Unveil New Innovations",
        "description":
            "Latest advancements in technology from leading companies...",
        "color": Colors.blue[500],
      },
      {
        "image":
            "https://lh3.googleusercontent.com/aida-public/AB6AXuB7PIgKnSWh2AFQBBAm44oQQSok3nTjTvw3IUb361lpRVVtpceMJz5nNRzxbvyaHRUHWgWHz5AIw4g_QjipBX0_R0qwFet0AJDOPpvJfAID-G5gB_Jk49fvovSaUZg9euCmrBr63yUSnlveofxZXiseSeBaV7G7Lm6524VOOkIMfq1YP_7Dld5X_gKXpHecBX3F7_Axtr3LoAiQ_ggd-qT2rFqGKAiwEKnxDTxM34-rBioihln4Sv8ozXjyr24edAKklmTLTVVVyAg",
        "category": "Environment",
        "title": "Climate Change Summit Concludes",
        "description":
            "Key decisions and commitments from the global summit...",
        "color": Colors.green[500],
      },
      {
        "image":
            "https://lh3.googleusercontent.com/aida-public/AB6AXuD6BU1pzdCV4TBtHssZopScNmm2eNdFGLbi9Te46QauMtAQGXuaaK8XhiV4nXIfu1WAa2jJTOSIphae-xk1DdlU-SmTA0WXoV9UH6SF3gDNx0LTiOrgRih2ZTaDThfro5wX4sJkRFEWwvZZuQiH9KcsN8FWo2okwv8fF_Qn3GVVKFkiQSFholpt3NIxN7qXWazdTlRczytP66qZisKFFs9_5lxJsGC-teVfCYUzP6WGaG2ldF1rRsyOxax9PKuLqBRYxXolJe63k0E",
        "category": "Travel",
        "title": "Summer Travel Destinations",
        "description":
            "Top spots for your next vacation, offering unique experiences...",
        "color": Colors.red[500],
      },
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: featuredArticles.length,
          itemBuilder: (context, index) {
            final article = featuredArticles[index];
            return Padding(
              // Memberi jarak antar kartu dan padding di awal/akhir list
              padding: EdgeInsets.only(
                left: index == 0 ? 16.0 : 8.0,
                right: index == featuredArticles.length - 1 ? 16.0 : 8.0,
              ),
              child: FeaturedArticleCard(
                imageUrl: article["image"] as String,
                category: article["category"] as String,
                title: article["title"] as String,
                description: article["description"] as String,
                categoryColor: article["color"] as Color,
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget untuk section berita terbaru
  Widget _buildLatestNewsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest News',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<NewsArticle>>(
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
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: latestNews.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final news = latestNews[index];
                  return LatestNewsCard(
                    imageUrl: news.featuredImageUrl,
                    category: news.category,
                    // Or use news.category if available
                    title: news.title,
                    description: news.summary,
                    categoryColor: Colors.blue[600]!, // Adjust as needed
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// Widget kustom untuk kartu berita utama
class FeaturedArticleCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String description;
  final Color categoryColor;

  const FeaturedArticleCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.description,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan MediaQuery untuk mendapatkan 85% lebar layar
    final cardWidth = MediaQuery.of(context).size.width * 0.85;

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              // Error handling untuk gambar
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 48),
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            // Konten Teks
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[200], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget kustom untuk kartu berita terbaru
class LatestNewsCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String description;
  final Color categoryColor;

  const LatestNewsCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.description,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 48),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
