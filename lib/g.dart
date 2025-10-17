import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'about.dart';

class GScreen extends StatelessWidget {
  const GScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: _backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("About",
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
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: _backgroundGradient),
          ),
          backgroundColor: Colors.transparent,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: _cardGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text("The Assistive Smart Glove for Sign Language Interpretation is an innovative system designed to bridge the communication gap between individuals with hearing or speech impairments and the hearing community. It combines a wearable smart glove equipped with flex sensors and an MPU6050 motion sensor to detect hand gestures representing sign language. These detected gestures are sent wirelessly to a mobile application, where they are interpreted and displayed as text and converted into speech in real time. The system also features interactive lessons for learning sign language and an upcoming camera-based gesture recognition feature to enhance user learning and signing accuracy. By integrating hardware and software, the system provides an accessible, user-friendly tool that promotes inclusivity and communication for the deaf and mute community.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.6,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }
}
