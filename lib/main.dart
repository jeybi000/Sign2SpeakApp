import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'home.dart'; // for HomeScreen

void main() {
  runApp(const Sign2SpeakApp());
}

class Sign2SpeakApp extends StatelessWidget {
  const Sign2SpeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // keep it simple; page draws its own gradient background
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: false,
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
  final PageController _controller = PageController();

  // Words/Home/Wi-Fi scheme gradient
  LinearGradient get _backgroundGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1F2A44),
          Color(0xFF2A3E68),
          Color(0xFF3A4F85),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1) Gradient background (no animated layer)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(gradient: _backgroundGradient),
            ),
          ),
          // 2) Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller,
                    children: const [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/hand_logo.png"),
                            height: 350,
                          ),
                          SizedBox(height: 1),
                          Text(
                            "SIGN2SPEAK+",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "SF Pro Display",
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.white, // headline on dark bg
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Breaking Barriers with Every Gesture",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "SF Pro Display",
                              fontSize: 16,
                              color: Colors.white70, // softer body
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/character.png"),
                            height: 342,
                          ),
                          SizedBox(height: 40),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              "Your First Step to Sign\nLanguage Made Easy.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "SF Pro Display",
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "Simple, step-by-step lessons made just for beginners!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "SF Pro Display",
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Dots with scheme colors
                SmoothPageIndicator(
                  controller: _controller,
                  count: 2,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Color(0xFF66A3FF), // light blue accent
                    dotColor: Color(0xFF2A3E68), // muted blue from gradient
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                  ),
                ),

                const SizedBox(height: 24),

                // Next / Continue button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66A3FF), // accent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if ((_controller.page ?? 0) < 1.0) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          fontFamily: "SF Pro Display",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
