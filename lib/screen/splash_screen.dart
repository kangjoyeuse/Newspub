import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newspub/screen/onboarding_screen.dart';
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
<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#3B82F6"><path d="M480-160q-48-38-104-59t-116-21q-42 0-82.5 11T100-198q-21 11-40.5-1T40-234v-482q0-11 5.5-21T62-752q46-24 96-36t102-12q58 0 113.5 15T480-740v484q51-32 107-48t113-16q36 0 70.5 6t69.5 18v-480q15 5 29.5 10.5T898-752q11 5 16.5 15t5.5 21v482q0 23-19.5 35t-40.5 1q-37-20-77.5-31T700-240q-60 0-116 21t-104 59Zm80-200v-380l200-200v400L560-360Zm-160 65v-396q-33-14-68.5-21.5T260-720q-37 0-72 7t-68 21v397q35-13 69.5-19t70.5-6q36 0 70.5 6t69.5 19Zm0 0v-396 396Z"/></svg>
''';

  @override
  void initState() {
    super.initState();
    // Set timer to navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      // Replace 'NextScreen()' with your target screen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => OnboardingScreen()));
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
