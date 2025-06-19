import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  
  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ArticleItem> userArticles = [
    ArticleItem(
      id: "1",
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuC6t_1F-8In5p9aoUyLLUYUTFGz4BoAwEPEfNsFB5s0vcpZ7ZUKDIV3wGHOQh2dLKCHpPAm-_enC1UXJMGjYjmMAWDQGe_QPhxevYfwyVzSyS_NUclrGTdCWW0SUPhQMryRu8tI2IdR2dURuk1iucqscbXn4kfgA9LUAzTVPAoGJuekEgCRT-Cesapni2wND6ynnJOeptB6PXgIXZue5_TZSeeRY41s13CD3rT71r6SRh0b6qaxLBgV_CKKJEWETn8FUcPOeyDv2KY",
      title: "My Tech Innovation Article",
      description: "A comprehensive look at the latest technological advancements and their impact on society.",
      category: "Technology",
      publishDate: "2024-06-15",
      status: "Published",
    ),
    ArticleItem(
      id: "2",
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuB7PIgKnSWh2AFQBBAm44oQQSok3nTjTvw3IUb361lpRVVtpceMJz5nNRzxbvyaHRUHWgWHz5AIw4g_QjipBX0_R0qwFet0AJDOPpvJfAID-G5gB_Jk49fvovSaUZg9euCmrBr63yUSnlveofxZXiseSeBaV7G7Lm6524VOOkIMfq1YP_7Dld5X_gKXpHecBX3F7_Axtr3LoAiQ_ggd-qT2rFqGKAiwEKnxDTxM34-rBioihln4Sv8ozXjyr24edAKklmTLTVVVyAg",
      title: "Environmental Sustainability Report",
      description: "Exploring green initiatives and their effectiveness in combating climate change.",
      category: "Environment",
      publishDate: "2024-06-10",
      status: "Draft",
    ),
  ];

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.beVietnamPro(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, {'logout': true}); // Return to home with logout flag
              },
              child: Text(
                'Logout',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.red[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteArticle(String articleId) {
    setState(() {
      userArticles.removeWhere((article) => article.id == articleId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Article deleted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _createNewArticle() {
    // TODO: Navigate to create article screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create Article feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _editArticle(ArticleItem article) {
    // TODO: Navigate to edit article screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit "${article.title}" feature coming soon'),
        duration: const Duration(seconds: 2),
      ),
    );
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
          'My Profile',
          style: GoogleFonts.beVietnamPro(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF475569)),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFF1F5F9),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: widget.userData['author']['avatarUrl'] != null
                      ? NetworkImage(widget.userData['author']['avatarUrl'])
                      : null,
                  backgroundColor: const Color(0xFF207BF3),
                  child: widget.userData['author']['avatarUrl'] == null
                      ? Text(
                          widget.userData['author']['firstName'][0],
                          style: GoogleFonts.beVietnamPro(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.userData['author']['firstName']} ${widget.userData['author']['lastName']}',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.userData['author']['email'] ?? 'Admin',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${userArticles.length} Articles Published',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: const Color(0xFF207BF3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Articles Section Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Articles',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _createNewArticle,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'New Article',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF207BF3),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Articles List
          Expanded(
            child: userArticles.isEmpty 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No articles yet',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start creating your first article',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _createNewArticle,
                        icon: const Icon(Icons.add),
                        label: const Text('Create Article'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF207BF3),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: userArticles.length,
                  itemBuilder: (context, index) {
                    final article = userArticles[index];
                    return ProfileArticleCard(
                      article: article,
                      onEdit: () => _editArticle(article),
                      onDelete: () => _deleteArticle(article.id),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}

class ArticleItem {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String category;
  final String publishDate;
  final String status;

  ArticleItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.category,
    required this.publishDate,
    required this.status,
  });
}

class ProfileArticleCard extends StatelessWidget {
  final ArticleItem article;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileArticleCard({
    super.key,
    required this.article,
    required this.onEdit,
    required this.onDelete,
  });

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF207BF3)),
                title: Text(
                  'Edit Article',
                  style: GoogleFonts.beVietnamPro(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red[600]),
                title: Text(
                  'Delete Article',
                  style: GoogleFonts.beVietnamPro(
                    color: Colors.red[600],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Article',
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${article.title}"? This action cannot be undone.',
            style: GoogleFonts.beVietnamPro(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              child: Text(
                'Delete',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.red[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
          onTap: () => _showActionSheet(context),
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: article.status == 'Published' 
                                  ? Colors.green[100] 
                                  : Colors.orange[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              article.status,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: article.status == 'Published' 
                                    ? Colors.green[700] 
                                    : Colors.orange[700],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            article.publishDate,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
                // More Actions Button
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: () => _showActionSheet(context),
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xFF64748B),
                      size: 20,
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