import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../apiservice.dart';
import '../newsmodel.dart';

class ArticleFormScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final NewsArticle? article; // null for create, non-null for edit

  const ArticleFormScreen({
    super.key,
    required this.userData,
    this.article,
  });

  @override
  State<ArticleFormScreen> createState() => _ArticleFormScreenState();
}

class _ArticleFormScreenState extends State<ArticleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController(); // Changed to TextEditingController
  final _tagsController = TextEditingController();

  bool _isPublished = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // If editing, populate fields with existing data
    if (widget.article != null) {
      _titleController.text = widget.article!.title;
      _summaryController.text = widget.article!.summary;
      _contentController.text = widget.article!.content;
      _imageUrlController.text = widget.article!.featuredImageUrl;
      _categoryController.text = widget.article!.category; // Use text controller
      _tagsController.text = widget.article!.tags.join(', ');
      _isPublished = widget.article!.isPublished;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose(); // Don't forget to dispose
    _tagsController.dispose();
    super.dispose();
  }

  List<String> _parseTags() {
    return _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  Future<void> _saveArticle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final tags = _parseTags();
      Map<String, dynamic> result;

      if (widget.article == null) {
        // Create new article
        result = await createArticle(
          token: widget.userData['token'],
          title: _titleController.text.trim(),
          summary: _summaryController.text.trim(),
          content: _contentController.text.trim(),
          featuredImageUrl: _imageUrlController.text.trim(),
          category: _categoryController.text.trim(), // Use text field value
          tags: tags,
          isPublished: _isPublished,
        );
      } else {
        // Update existing article
        result = await updateArticle(
          token: widget.userData['token'],
          articleId: widget.article!.id,
          title: _titleController.text.trim(),
          summary: _summaryController.text.trim(),
          content: _contentController.text.trim(),
          featuredImageUrl: _imageUrlController.text.trim(),
          category: _categoryController.text.trim(), // Use text field value
          tags: tags,
          isPublished: _isPublished,
        );
      }

      if (result['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.article != null;

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
          isEditing ? 'Edit Article' : 'Create Article',
          style: GoogleFonts.beVietnamPro(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveArticle,
              child: Text(
                'Save',
                style: GoogleFonts.beVietnamPro(
                  color: const Color(0xFF207BF3),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'Enter article title',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Summary Field
              _buildTextField(
                controller: _summaryController,
                label: 'Summary',
                hint: 'Enter article summary',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Summary is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Content Field
              _buildTextField(
                controller: _contentController,
                label: 'Content',
                hint: 'Enter article content',
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Content is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Featured Image URL Field
              _buildTextField(
                controller: _imageUrlController,
                label: 'Featured Image URL',
                hint: 'Enter image URL',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Featured image URL is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Field (Changed from dropdown to text field)
              _buildTextField(
                controller: _categoryController,
                label: 'Category',
                hint: 'Enter article category (e.g., Technology, Sports, Politics)',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tags Field
              _buildTextField(
                controller: _tagsController,
                label: 'Tags',
                hint: 'Enter tags separated by commas',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'At least one tag is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Publish Status
              Row(
                children: [
                  Text(
                    'Publish Status',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: _isPublished,
                    onChanged: (value) {
                      setState(() {
                        _isPublished = value;
                      });
                    },
                    activeColor: const Color(0xFF207BF3),
                  ),
                  Text(
                    _isPublished ? 'Published' : 'Draft',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: _isPublished ? Colors.green[600] : Colors.orange[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveArticle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF207BF3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEditing ? 'Update Article' : 'Create Article',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.beVietnamPro(
              color: Colors.grey[400],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          style: GoogleFonts.beVietnamPro(),
        ),
      ],
    );
  }
}
