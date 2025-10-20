import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'j.dart';
import 'p.dart';
import 'r.dart';
import 'm.dart';
import 'g.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text("ABOUT US",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D1E25),
            letterSpacing: .8,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1F2A44), 
                    Color(0xFF2A3E68), 
                    Color(0xFF3A4F85), 
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: const Color(0xFF5B8CFF).withOpacity(.18),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              // ignore: deprecated_member_use
                              color: const Color(0xFF5B8CFF).withOpacity(.5),
                            ),
                          ),
                          child: Text("Assistive Technology",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF9CC2FF),
                              letterSpacing: .3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("Sign2Speak+",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: .3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("From silent signs to loud connections!",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(.88),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5B8CFF),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const GScreen()),
                            );
                          },
                          child: Text("Know about the system",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/character.png",
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            
            _buildMemberCard(
              context,
              image: "assets/perez.jpg",
              name: "John Vincent Perez",
              role: "Programmer",
              route: const PScreen(),
              accentColor: const Color(0xFF9C6BFF),
            ),
            const SizedBox(height: 16),
            _buildMemberCard(
              context,
              image: "assets/rile.png",
              name: "John Dominic Rile",
              role: "UI/UX",
              route: const RScreen(),
              accentColor: const Color(0xFF2BD9C8),
            ),
            const SizedBox(height: 16),
            _buildMemberCard(
              context,
              image: "assets/endozo.jpg",
              name: "Jessica Endozo",
              role: "Documentation",
              route: const JScreen(),
              accentColor: const Color(0xFF5B8CFF), 
            ),
            const SizedBox(height: 16),
            _buildMemberCard(
              context,
              image: "assets/solmiano.jpg",
              name: "Dennis Marvin Solmiano",
              role: "Documentation",
              route: const MScreen(),
              accentColor: const Color(0xFFFFC857), 
            ),

            const SizedBox(height: 15),

            _dividerWithLabel(""),

            const SizedBox(height: 15),

            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 80,
              runSpacing: 14,
              children: [
                Opacity(
                  opacity: .95,
                  child: Image.asset("assets/scsLOGO.png", width: 85),
                ),
                Opacity(
                  opacity: .95,
                  child: Image.asset("assets/cctLOGO.png", width: 60),
                ),
              ],
            ),

            const SizedBox(height: 10),
            
            Text("Sign2Speak+",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7180),
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context, {
    required String image,
    required String name,
    required String role,
    required Widget route,
    required Color accentColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0x0F000000)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(image),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1D1E25),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          role,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7180),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
           const Icon(Icons.chevron_right, color: Color(0xFF9AA0A6), size: 22),
          ],
        ),
      ),
    );
  }

  Widget _dividerWithLabel(String label) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFE7E9EE),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7180),
            letterSpacing: .3,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFE7E9EE),
          ),
        ),
      ],
    );
  }
}
