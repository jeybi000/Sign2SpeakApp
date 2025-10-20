import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'home.dart';

void main() {
  runApp(const Sign2SpeakApp());
}

class Sign2SpeakApp extends StatelessWidget {
  const Sign2SpeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        // ignore: deprecated_member_use
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(gradient: _backgroundGradient),
            ),
          ),
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
                          Text("SIGN2SPEAK+",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "SF Pro Display",
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.white, 
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Breaking Barriers with Every Gesture",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "SF Pro Display",
                              fontSize: 16,
                              color: Colors.white70, 
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
                            child: Text("Your First Step to Sign\nLanguage Made Easy.",
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
                            child: Text("Simple, step-by-step lessons made just for beginners!",
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

                SmoothPageIndicator(
                  controller: _controller,
                  count: 2,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Color(0xFF66A3FF), 
                    dotColor: Color(0xFF2A3E68), 
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                  ),
                ),

                const SizedBox(height: 24),

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
