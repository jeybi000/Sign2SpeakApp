import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'about.dart';
import 'package:flip_card/flip_card.dart';

class GScreen extends StatefulWidget {
  const GScreen({super.key});

  @override
  State<GScreen> createState() => _GScreenState();
}

class _GScreenState extends State<GScreen>
    with SingleTickerProviderStateMixin {
  final PageController _aboutController =
      PageController(viewportFraction: 0.85);
  final ScrollController _hardwareScroll = ScrollController();
  final ScrollController _componentsScroll = ScrollController();

  double _hardwareProgress = 0.0;
  double _componentsProgress = 0.0;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
          ..forward();

    _hardwareScroll.addListener(() {
      setState(() {
        _hardwareProgress = _hardwareScroll.offset /
            (_hardwareScroll.position.maxScrollExtent == 0
                ? 1
                : _hardwareScroll.position.maxScrollExtent);
      });
    });

    _componentsScroll.addListener(() {
      setState(() {
        _componentsProgress = _componentsScroll.offset /
            (_componentsScroll.position.maxScrollExtent == 0
                ? 1
                : _componentsScroll.position.maxScrollExtent);
      });
    });
  }

  @override
  void dispose() {
    _hardwareScroll.dispose();
    _componentsScroll.dispose();
    _aboutController.dispose();
    _animController.dispose();
    super.dispose();
  }

  LinearGradient get _backgroundGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0C1220),
          Color(0xFF101829),
        ],
      );

  LinearGradient get _cardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF151B2F),
          Color(0xFF1C2336),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = (screenWidth / 2) - 17;
    const double cardHeight = 200;

    final aboutTexts = [
      "This prototype for sign language interpretation is an innovative assistive technology developed to bridge the communication gap between individuals with hearing and speech impairments and those who do not understand sign language.",
      "The system features a wearable smart glove integrated with various sensors, including potentiometers for detecting finger bending and an MPU6050 accelerometer and gyroscope for tracking hand movement and orientation. A push button is also incorporated to serve as a contact point for the thumb.",
      "Sensor data collected by the glove is processed through a microcontroller (ESP32) and transmitted wirelessly to a mobile application. The application interprets the recognized gestures into corresponding text and speech outputs, enabling real-time and accessible communication between users."
    ];

    final components = [
      {
        "name": "ESP32",
        "image": "assets/esp32PNG.png",
        "desc":
            "Low-cost microcontroller with built-in Wi-Fi and Bluetooth for wireless data transmission."
      },
      {
        "name": "MPU6050",
        "image": "assets/mpu6050PNG.png",
        "desc":
            "6-axis motion sensor combining accelerometer and gyroscope for orientation and movement tracking."
      },
      {
        "name": "Booster Power Module",
        "image": "assets/boostermodulePNG.png",
        "desc": "Boosts power supply voltage to ensure stable component operation."
      },
      {
        "name": "ADS1115",
        "image": "assets/ads1115PNG.png",
        "desc": "16-bit ADC module that converts analog signals into digital readings."
      },
      { 
        "name": "Potentiometer", 
        "image": "assets/potentiometerPNG.png", 
        "desc": "Type of variable resistor used to adjust voltage or signal levels in electronic circuits." 
      },  
      { 
        "name": "Mini Rocker Switch", 
        "image": "assets/switchPNG.png", 
        "desc": "A small on/off switch that controls the flow of current in a circuit by rocking back and forth between two positions." 
      }, 
      { 
        "name": "Silicone Coated Glove", 
        "image": "assets/glovePNG.png", 
        "desc": "Serves as the base of the smart glove, providing flexibility, durability, and stable surface for mounting sensors and electronic components." 
      }, 
      { 
        "name": "Perf Board/Proto Board", 
        "image": "assets/perfboardPNG.png", 
        "desc": "A board with pre-drilled holes used for mounting and soldering electronic components to create circuits." 
      },
    ];

    return Container(
      decoration: BoxDecoration(gradient: _backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "About",
            style: GoogleFonts.inter(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
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
          backgroundColor: Colors.transparent,
        ),
        body: FadeTransition(
          opacity: _animController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _animController,
              curve: Curves.easeOutCubic,
            )),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 180,
                    child: PageView.builder(
                      controller: _aboutController,
                      itemCount: aboutTexts.length,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: _cardGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x66000000),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              aboutTexts[index],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                height: 1.6,
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Hardware",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0066FF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: cardHeight,
                    child: SingleChildScrollView(
                      controller: _hardwareScroll,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _hardwareCard("assets/3dGLOVE.png", "Smart Glove",
                              cardWidth, cardHeight),
                          const SizedBox(width: 8),
                          _hardwareCard("assets/3dPOTENTIOMETERCLAW.png",
                              "Finger Frame", cardWidth, cardHeight),
                          const SizedBox(width: 8),
                          _hardwareCard("assets/3dCASE.png", "Component Case",
                              cardWidth, cardHeight),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDynamicIndicator(_hardwareProgress),
                  const SizedBox(height: 30),
                  Text(
                    "Components",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0066FF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: cardHeight,
                    child: SingleChildScrollView(
                      controller: _componentsScroll,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var comp in components) ...[
                            _componentCard(comp, cardWidth, cardHeight),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDynamicIndicator(_componentsProgress),
                  const SizedBox(height: 30),
                  Text(
                    "Step-by-Step Tutorial",
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF418DFF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTutorialSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialSection() {
    final tutorialSteps = [
      "Wear the smart glove properly.",
      "Power on the system using the mini rocker switch.",
      "Wait for the ESP32 to connect to the mobile app.",
      "Open the Sign2Speak+ app and enable Wi-Fi.",
      "Perform gestures clearly for accurate detection.",
      "View interpreted text and speech output.",
      "After use, power off the device."
    ];

    return Column(
      children: List.generate(tutorialSteps.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 10),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF0066FF),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${index + 1}",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tutorialSteps[index],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.5,
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDynamicIndicator(double progress) {
    const count = 3;
    final activeIndex = (progress * count).clamp(0, count - 1).toInt();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 22 : 14,
          height: 3,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF0066FF)
                // ignore: deprecated_member_use
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  Widget _hardwareCard(
      String image, String label, double width, double height) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: _cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _componentCard(Map<String, String> comp, double width, double height) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: _cardGradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(comp["image"]!, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              comp["name"]!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      back: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: _cardGradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            comp["desc"]!,
            style: GoogleFonts.inter(
              fontSize: 12,
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
