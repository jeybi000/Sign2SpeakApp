import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

class WordsPage extends StatelessWidget {
  const WordsPage({super.key});

  LinearGradient get _backgroundGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1F2A44),
          Color(0xFF2A3E68),
          Color(0xFF3A4F85),
        ],
      );

  LinearGradient get _cardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF21263A),
          Color(0xFF2A3E68),
        ],
      );

  List<Map<String, String>> get words => const [
        {"label": "Hello", "asset": "assets/words/hello.png"},
        {"label": "Yes", "asset": "assets/words/yes.png"},
        {"label": "No", "asset": "assets/words/no.png"},
        {"label": "Thank you", "asset": "assets/words/thankyou.png"},
        {"label": "Me", "asset": "assets/words/me.png"},
        {"label": "You", "asset": "assets/words/you.png"},
        {"label": "Eat", "asset": "assets/words/eat.png"},
        {"label": "I love you", "asset": "assets/words/iloveyou.png"},
        {"label": "Good", "asset": "assets/words/good.png"},
        {"label": "Deaf", "asset": "assets/words/deaf.png"},
        {"label": "Mute", "asset": "assets/words/mute.png"},
        {"label": "Please", "asset": "assets/words/please.png"},
        {"label": "Read", "asset": "assets/words/read.png"},
        {"label": "Learn", "asset": "assets/words/learn.png"},
        {"label": "Quiet", "asset": "assets/words/quiet.png"},
        {"label": "Help", "asset": "assets/words/help.png"},
        {"label": "Sorry", "asset": "assets/words/sorry.png"},
        {"label": "Better", "asset": "assets/words/better.png"},
        {"label": "Call", "asset": "assets/words/call.png"},
        {"label": "Table", "asset": "assets/words/table.png"},
        {"label": "Fine", "asset": "assets/words/fine.png"},
        {"label": "Water", "asset": "assets/words/water.png"},
        {"label": "Milk", "asset": "assets/word/milk.png"},
        {"label": "Name", "asset": "assets/words/name.png"},
        {"label": "Glasses", "asset": "assets/words/glasses.png"},
        {"label": "Know", "asset": "assets/words/know.png"},
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Basic Words",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            }
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: _backgroundGradient),
        ),
        backgroundColor: Colors.transparent,
      ),

      body: Container(
        decoration: BoxDecoration(gradient: _backgroundGradient),
        child: Stack(
          children: [
            Positioned(
              right: -60,
              top: 100,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Easily learn common and\neveryday words in sign language!",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Tap a card to preview the sign image.",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        final item = words[index];
                        return _wordCard(
                          context,
                          label: item["label"]!,
                          assetPath: item["asset"]!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wordCard(BuildContext context,
      {required String label, required String assetPath}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => showWordDialog(context, label, assetPath),
      child: Container(
        decoration: BoxDecoration(
          gradient: _cardGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.25,
            ),
          ),
        ),
      ),
    );
  }

  void showWordDialog(BuildContext context, String label, String assetPath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFF1E1E2D),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, _, __) {
                        return Container(
                          color: const Color(0xFF26263A),
                          alignment: Alignment.center,
                          child: Text(
                            "Image not found:\n$assetPath",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close,
                        color: Colors.white70, size: 18),
                    label: Text(
                      "Close",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
