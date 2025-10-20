import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'about.dart';
import 'alpha.dart';
import 'words.dart';
import 'speak.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedAlphabetBackground()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome!",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Sign2Speak+",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0066FF),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildCard(
                    context,
                    title: "Alphabet",
                    subtitle:
                        "Learn the sign language \n alphabet the easy and fun \n way!",
                    page: const AlphaPage(),
                  ),
                  const SizedBox(height: 25),
                  _buildCard(
                    context,
                    title: "Basic Words",
                    subtitle:
                        "Talk with your hands—\nmaster everyday signs the\nfun way",
                    page: const WordsPage(),
                  ),
                  const SizedBox(height: 25),
                  _buildCard(
                    context,
                    title: "Sign to Speak",
                    subtitle: "Turning gestures into\n conversations!",
                    page: const SpeakScreen(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0E0E17),
        selectedItemColor: const Color(0xFF0066FF),
        unselectedItemColor: Colors.white70,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WifiStatusPage()),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "About"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "Status"),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    Widget? page,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF141622),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              elevation: 0,
            ),
            onPressed: () {
              if (page != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              }
            },
            child: Text(
              "Start now",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Updated connection logic from first version, UI kept from second
class WifiStatusPage extends StatefulWidget {
  const WifiStatusPage({super.key});
  @override
  State<WifiStatusPage> createState() => _WifiStatusPageState();
}

class _WifiStatusPageState extends State<WifiStatusPage> {
  bool? isConnected;
  bool isLoading = false;
  Timer? _connectionTimer;
  int _failCount = 0;
  bool _hasShownSnackbar = false;
  final String esp32Url = "http://192.168.4.1:80";

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _connectionTimer =
        Timer.periodic(const Duration(minutes: 1), (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    if (isLoading) return;
    if (mounted) setState(() => isLoading = true);

    try {
      // Try socket connection first
      final sock = await Socket.connect('192.168.4.1', 80,
          timeout: const Duration(seconds: 2));
      await sock.close();

      try {
        // Then verify via HTTP
        final r = await http
            .get(Uri.parse(esp32Url))
            .timeout(const Duration(seconds: 2));
        if (r.statusCode >= 500) {
          _incrementFail();
        } else if (mounted) {
          setState(() {
            isConnected = true;
            _failCount = 0;
            _hasShownSnackbar = false;
          });
        }
      } on TimeoutException {
        if (mounted) {
          setState(() {
            isConnected = true;
            _failCount = 0;
            _hasShownSnackbar = false;
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() {
            isConnected = true;
            _failCount = 0;
            _hasShownSnackbar = false;
          });
        }
      }
    } on SocketException {
      _incrementFail();
    } on TimeoutException {
      _incrementFail();
    } catch (_) {
      _incrementFail();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }

    if (_failCount >= 3 && !_hasShownSnackbar) {
      _handleConnectionLost();
    }
  }

  void _incrementFail() {
    _failCount++;
    if (mounted) setState(() => isConnected = false);
  }

  void _handleConnectionLost() {
    _hasShownSnackbar = true;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connection Lost!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _connectionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Wi-Fi Status",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF0066FF),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: Color(0xFF0066FF))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isConnected == true ? Icons.wifi : Icons.wifi_off,
                    size: 100,
                    color: isConnected == true
                        ? const Color(0xFF2BD9C8)
                        : const Color(0xFFFF5E5E),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isConnected == true ? "Connected!" : "Disconnected!",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _checkConnection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Refresh",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AnimatedAlphabetBackground extends StatefulWidget {
  final double density;
  final double speed;
  final double maxFontSize;

  const AnimatedAlphabetBackground({
    super.key,
    this.density = 0.7,
    this.speed = 1.0,
    this.maxFontSize = 35,
  });

  @override
  State<AnimatedAlphabetBackground> createState() =>
      _AnimatedAlphabetBackgroundState();
}

class _AnimatedAlphabetBackgroundState extends State<AnimatedAlphabetBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_LetterParticle> _particles;
  Size _lastSize = Size.zero;
  final _rand = math.Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..addListener(() => setState(() {}))
          ..repeat();
    _particles = [];
  }

  void _ensureParticles(Size size) {
    if (size == _lastSize && _particles.isNotEmpty) return;
    _lastSize = size;
    final count = ((size.width * size.height) / 12000).clamp(15, 70).toInt();

    _particles = List.generate(count, (_) {
      final letter = String.fromCharCode(65 + _rand.nextInt(26));
      return _LetterParticle(
        letter: letter,
        position: Offset(
            _rand.nextDouble() * size.width, _rand.nextDouble() * size.height),
        velocity: Offset(
            (_rand.nextDouble() - 0.5) * 0.6, (_rand.nextDouble() - 0.5) * 0.6),
        fontSize: 12 + _rand.nextDouble() * (widget.maxFontSize - 12),
        angle: _rand.nextDouble() * math.pi * 2,
        baseOpacity: 0.15 + _rand.nextDouble() * 0.2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _AlphabetPainter(_particles, _controller.value),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            _ensureParticles(size);
            for (final p in _particles) {
              p.position += p.velocity;
              if (p.position.dx < -40) {
                p.position = Offset(size.width, p.position.dy);
              }
              if (p.position.dx > size.width) {
                p.position = Offset(0, p.position.dy);
              }
              if (p.position.dy < -40) {
                p.position = Offset(p.position.dx, size.height);
              }
              if (p.position.dy > size.height) {
                p.position = Offset(p.position.dx, 0);
              }
            }
            return const SizedBox.expand();
          },
        ),
      ),
    );
  }
}

class _LetterParticle {
  String letter;
  Offset position;
  Offset velocity;
  double fontSize;
  double angle;
  double baseOpacity;
  _LetterParticle({
    required this.letter,
    required this.position,
    required this.velocity,
    required this.fontSize,
    required this.angle,
    required this.baseOpacity,
  });
}

class _AlphabetPainter extends CustomPainter {
  final List<_LetterParticle> particles;
  final double time;
  _AlphabetPainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    const color = Color(0xFF66A3FF);
    for (final p in particles) {
      final tp = TextPainter(
        text: TextSpan(
          text: p.letter,
          style: GoogleFonts.poppins(
            color: color.withOpacity(p.baseOpacity),
            fontSize: p.fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(p.position.dx, p.position.dy);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
