import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookmarkScreen extends StatefulWidget {
  final Map<String, dynamic>? userData; // Pass userData from home screen
  
  const BookmarkScreen({super.key, this.userData});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final List<BookmarkItem> bookmarkedArticles = [
    BookmarkItem(
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuB8ax-IVq54om1a4DOgY6UG57pl8WT7jZ1_K0euY8_Bxn6TmB0PtIObM6PLa-v4iQ14INfM-yarahxq2U0hTg8fPHqndK42RtCgVtDbOyXVl7cHIPtzsFU2wxamjGUMDdeSsjO6hEK9TqcRqx_5DH6Rtv0idVuOufXSbiloFEo-phgqHTpO7UQtbpw4wy1RPPMiZsLdww7XOUxxxm2OSYFPNKBBGAlYIdvaGLhsvxAY8IDI-Pw9qV5VDeWY1nl2xgB8heMo2yaXDew",
      title: "Tech Giants Unveil New Innovations",
      description: "A brief summary of the latest technological advancements from leading companies, focusing on AI and sustainable tech.",
      category: "Technology",
    ),
    BookmarkItem(
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDtrNqjxxQDFpaa3Nplwf4ZSlM2nCBfZSZoMpc4UBQsjWmbs9CWjB0_PDejBf3eu1uAN8p_TvUqvdu2NHhQ45cDJPpV4sqUJAjzi-pBybFLIdXAtv5yuRNtOLUNUU5k2V2e5sndnQ2Xr7MeZCP8fQBZFGDbge_KRsVCoL2TVLzLJ4N53jN3X_U6t9_B3OcX_szqrg2C1r7h7EQtY4rOmxanNeRhNyrhNmx3s8-g6ltS0xAnZIzkXYNAZXr9nbtef9DsVOjwq8wbqxM",
      title: "Government Announces New Policy Changes",
      description: "Details on the newly announced government policies and their potential impact on the economy and society.",
      category: "Politics",
    ),
    BookmarkItem(
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuAUAaWTkS-PvZo6LJGrOovQfKMj2PR6tJhyefGJifKeB5bEAzHRZR7wKkFJIs_gES1N5NY9iMrBhumMGtBb7ZKv0sLFjYEy2R6WALmfN4fQY069kOOISDcFRjk3shuB-VyPAAVFXCByLvHmTrgMe9_CwpZvi3hY4JEFk-01JviKAajCS_O2-iBwwwNZYV7Wy3Lgm-V5wZ5kGfHZm7KhnMZ4AijTDaV8u6C8i8DysMurhJXUF1q5A9XnpvUEc9Lcak9yErVS8zz3Jbk",
      title: "Local Team Wins Championship",
      description: "An exciting recap of the championship game where the local team emerged victorious after a thrilling match.",
      category: "Sports",
    ),
    BookmarkItem(
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuD5HFmd8R0USx6ssvx0xQmK6mnCcWjMJE3YI-otCSEL2qYoaRkc_3HAO1-q-1ILmHrBAoevLS_yQAwk3aWG0JdCMTM-hnNRYgGNRGigZN1fEblqDOJppCUu_soywiPcbFztmH4OBXFh3-PI912S_zymcCzAfpW2QTj_8hG5EoA4LkC3wFq23w7_exA2B0_AX0YeDXQG7yGs0UCbtH3h86uf57JxTctd7nFX7Eop_cdhiZOiVtI1CFAZp7WOwsrH6JdWyEU0nqjiUu8",
      title: "Market Trends Show Positive Growth",
      description: "An analysis of recent market data indicating a positive growth trajectory across various sectors.",
      category: "Business",
    ),
    BookmarkItem(
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCcPr02UiwOxmp5VMWkXibnDd7wzLmmv0K8_pny-GwMZT6aKN8mY7l3zYyd-YlN5A4qe76ruxPMilL0D3PDZLNWcRUTR8Ns6OnOPb8MwdHIUMVUE1NAYGv1OsyfjSaKWYYtxvcaBxQMwY5_hxW_NuwJSiCDFmr95i42GECq_eSG4gBGwqLBaSlAvu4qfVmr4cRtvl8qd4XoW16qj43ghbcJ2k6QEX5Mw3l3kongNOtPlmsmRfog1IjyjINSzq5ecdSBqmubVIKuHk4",
      title: "New Health Guidelines Released",
      description: "Public health officials have released new guidelines aimed at improving community well-being.",
      category: "Health",
    ),
  ];

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
      body: bookmarkedArticles.isEmpty 
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
        : ListView.builder(
            itemCount: bookmarkedArticles.length,
            itemBuilder: (context, index) {
              final article = bookmarkedArticles[index];
              return BookmarkCard(
                article: article,
                onRemoveBookmark: () {
                  setState(() {
                    bookmarkedArticles.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Removed from bookmarks'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}

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
}

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
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            // Handle article tap - navigate to article detail
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 96,
                    height: 96,
                    color: const Color(0xFFE2E8F0),
                    child: Image.network(
                      article.imageUrl,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 48),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Article Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                          height: 1.3,
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
                // Bookmark Button
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: onRemoveBookmark,
                    icon: const Icon(
                      Icons.bookmark,
                      color: Color(0xFF207BF3),
                      size: 24,
                    ),
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}