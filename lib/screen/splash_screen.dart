import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'dart:async'; // Add this import

// Theme
const Color primaryBlue = Color(0XFF007AFF);
const Color textPrimary = Color(0XFF0D141C);
const Color textSecondary = Color(0XFF49739C);
const Color spinnerGray = Color(0xFFD1D5DB);
const List<String> fontFallback = ["Roboto", "Arial"];

// Change to StatefulWidget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String svgIconData = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
    <path d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 12h6m-1 8h.01M5 8h.01M5 12h.01M5 16h.01M5 20h.01M9 4V3a1 1 0 011-1h4a1 1 0 011 1v1M9 8h6" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" fill="none" stroke="currentColor"></path>
</svg>
''';

  @override
  void initState() {
    super.initState();
    // Set timer to navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      // Replace 'NextScreen()' with your target screen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Color(0xff007aff),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.string(
                  svgIconData,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  height: 48,
                  width: 48,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Newspub",
              style: GoogleFonts.beVietnamPro(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            SizedBox(height: 32),
            SimpleCircularProgressBar(
              progressColors: [spinnerGray],
              size: 48,
              backStrokeWidth: 0,
              progressStrokeWidth: 4,
              mergeMode: true,
              animationDuration: 2,
            ),
            SizedBox(height: 16),
            Text(
              "Loading...",
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // Example of a target screen - replace with your actual screen
// class NextScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SplashScreen(),
//     );
//   }
// }
