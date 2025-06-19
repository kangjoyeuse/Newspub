import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newspub/screen/home_screen.dart';
import 'package:newspub/screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

// Data Model untuk setiap halaman onboarding
class OnboardingItem {
  final String image;
  final String title;
  final String description;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App Onboarding',
      theme: ThemeData(
        textTheme: GoogleFonts.beVietnamProTextTheme(Theme.of(context).textTheme),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  final List<OnboardingItem> _onboardingData = [
    OnboardingItem(
      image: 'https://i.imgur.com/4YU82t4.png',
      title: 'Berita Terkini & Terpercaya',
      description: 'Dapatkan pembaruan instan dari sumber terverifikasi di seluruh dunia, langsung di ujung jari Anda.',
    ),
    OnboardingItem(
      image: 'https://i.imgur.com/k7ENYmD.png',
      title: 'Kategori Sesuai Minat',
      description: 'Pilih topik yang Anda sukai, mulai dari teknologi, olahraga, hingga politik, dan kami akan menyajikannya untuk Anda.',
    ),
    OnboardingItem(
      image: 'https://i.imgur.com/YJzTwHS.png',
      title: 'Simpan & Baca Nanti',
      description: 'Jangan lewatkan artikel menarik. Simpan berita untuk dibaca nanti, bahkan saat Anda sedang offline.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const NewsHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ## Tombol Lewati (Skip) ##
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _navigateToHome,
                child: const Text(
                  'Lewati',
                  style: TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // ## Konten Slide (PageView) ##
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(item: _onboardingData[index]);
                },
              ),
            ),
            
            // REVISI: Indikator titik-titik sekarang berada di sini, di bawah PageView
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0), // Memberi jarak ke tombol di bawah
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: PageIndicator(isActive: index == _currentPageIndex),
                  ),
                ),
              ),
            ),

            // REVISI: Footer sekarang hanya berisi tombol navigasi
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPageIndex < _onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _navigateToHome();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      _currentPageIndex < _onboardingData.length - 1
                          ? 'Selanjutnya'
                          : 'Mulai',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Widget untuk menampilkan konten satu halaman onboarding
class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            item.image,
            height: MediaQuery.of(context).size.height * 0.35,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 48),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk indikator titik
class PageIndicator extends StatelessWidget {
  final bool isActive;
  const PageIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}