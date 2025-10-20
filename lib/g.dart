import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'about.dart';
import 'package:flip_card/flip_card.dart';

class GScreen extends StatefulWidget {
  const GScreen({super.key});

  @override
  State<GScreen> createState() => _GScreenState();
}

class _GScreenState extends State<GScreen> {
  final PageController _aboutController =
      PageController(viewportFraction: 0.85);
  final ScrollController _hardwareScroll = ScrollController();
  final ScrollController _componentsScroll = ScrollController();

  double _hardwareProgress = 0.0;
  double _componentsProgress = 0.0;

  @override
  void initState() {
    super.initState();

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
    super.dispose();
  }

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
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth =
        (screenWidth / 2) - 17; // fits 2 per row with spacing
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
            "The ESP32 is a low-cost microcontroller with built-in Wi-Fi and Bluetooth, used for wireless data transmission and control."
      },
      {
        "name": "MPU6050",
        "image": "assets/mpu6050PNG.png",
        "desc":
            "The MPU6050 is a 6-axis motion sensor that combines an accelerometer and a gyroscope to measure orientation and movement."
      },
      {
        "name": "Booster Power Module",
        "image": "assets/boostermodulePNG.png",
        "desc":
            "This module boosts the power supply voltage to ensure stable operation of components like sensors and microcontrollers."
      },
      {
        "name": "ADS1115",
        "image": "assets/ads1115PNG.png",
        "desc":
            "The ADS1115 is a 16-bit ADC module that converts analog signals from sensors into digital values for accurate readings."
      },
      {
        "name": "Potentiometer",
        "image": "assets/potentiometerPNG.png",
        "desc":
            "Type of variable resistor used to adjust voltage or signal levels in electronic circuits."
      },
      {
        "name": "Lithium Ion Battery",
        "image": "assets/lipobatteryPNG.png",
        "desc":
            "Type of rechargeable battery that uses lithium ions as the main component of its electrochemical cells."
      },
      {
        "name": "TP4056 Module",
        "image": "assets/tp4056PNG.png",
        "desc":
            "Lithium ion battery charging module that safely charges 3.7V batteries via a 5V USB input with built-in protection and status indicator."
      },
      {
        "name": "Mini Rocker Switch",
        "image": "assets/switchPNG.png",
        "desc":
            "A small on/off switch that controls the flow of current in a circuit by rocking back and forth between two positions."
      },
      {
        "name": "Silicone Coated Glove",
        "image": "assets/glovePNG.png",
        "desc":
            "Serves as the base of the smart glove, providing flexibility, durability, and stable surface for mounting sensors and electronic components."
      },
      {
        "name": "Perf Board/Proto Board",
        "image": "assets/perfboardPNG.png",
        "desc":
            "A board with pre-drilled holes used for mounting and soldering electronic components to create circuits."
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== System Info Carousel =====
              SizedBox(
                height: 180,
                child: PageView.builder(
                  controller: _aboutController,
                  itemCount: aboutTexts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
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
                      child: Center(
                        child: Text(
                          aboutTexts[index],
                          style: GoogleFonts.poppins(
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
              const SizedBox(height: 20),

              // ===== Hardware Section =====
              Text(
                "Hardware",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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

              // ===== Components Section =====
              Text(
                "Components",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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

              // ===== Step-by-Step Tutorial Section =====
              Text(
                "Step-by-Step Tutorial",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _buildTutorialSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Step-by-Step Tutorial Widget =====
  Widget _buildTutorialSection() {
    final tutorialSteps = [
      "Wear the smart glove properly, ensuring that all sensors and wires are securely connected.",
      "Power on the system by toggling the mini rocker switch located in the component case.",
      "Wait for the ESP32 to establish a wireless connection with the mobile application.",
      "Open the Sign2Speak mobile app on your device and ensure Wi-Fi is enabled.",
      "Perform the desired hand gestures slowly and clearly for accurate detection by the sensors.",
      "View the interpreted text displayed on the app’s screen, and listen to the generated speech output.",
      "After use, power off the device and safely disconnect the glove from the charging module if needed."
    ];

    return Column(
      children: List.generate(tutorialSteps.length, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: _cardGradient,
            borderRadius: BorderRadius.circular(12),
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
              // Step Number
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${index + 1}",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2A44),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Step Description
              Expanded(
                child: Text(
                  tutorialSteps[index],
                  style: GoogleFonts.poppins(
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

  // ===== Dynamic Indicator =====
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
          width: isActive ? 24 : 16,
          height: 3,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  // ===== Hardware Card =====
  Widget _hardwareCard(
      String image, String label, double width, double height) {
    return Container(
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
            style: GoogleFonts.poppins(
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

  // ===== Component Card =====
  Widget _componentCard(Map<String, String> comp, double width, double height) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: _cardGradient,
          borderRadius: BorderRadius.circular(16),
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
              style: GoogleFonts.poppins(
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
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            comp["desc"]!,
            style: GoogleFonts.poppins(
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
