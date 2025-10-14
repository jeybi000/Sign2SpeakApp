import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'about.dart';

class RScreen extends StatelessWidget {
  const RScreen({super.key});

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
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF21263A),
          Color(0xFF2A3E68),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: _backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Profile",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: _backgroundGradient),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage("assets/rile.png"),
              ),
              const SizedBox(height: 16),
              Text(
                "John Dominic",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                "UI/UX Mobile Developer",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),

              _buildInfoTile(
                  Icons.person_outline, "Full Name", "John Dominic M. Rile"),
              _buildInfoTile(Icons.email_outlined, "Email Address",
                  "johndominic.@gmail.com"),
              _buildInfoTile(
                  Icons.phone_outlined, "Phone Number", "+63078333770"),
              _buildInfoTile(Icons.cake, "Birth Date", "1 March 2004"),

              const SizedBox(height: 40),
              Text(
                "Sign2Speak+",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: _cardGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
