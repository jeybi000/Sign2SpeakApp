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
      backgroundColor: Colors.white, 
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(gradient: _backgroundGradient),
            ),
          ),
          const Positioned.fill(child: AnimatedAlphabetBackground()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome!",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white, 
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sign2Speak+",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF66A3FF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    context,
                    title: "Alphabet",
                    subtitle:
                        "Learn the sign language alphabet the easy and fun way!",
                    page: const AlphaPage(),
                  ),
                  const SizedBox(height: 30),
                  _buildCard(
                    context,
                    title: "Basic Words",
                    subtitle:
                        "Talk with your hands—\nmaster everyday signs the fun way",
                    page: const WordsPage(),
                  ),
                  const SizedBox(height: 30),
                  _buildCard(
                    context,
                    title: "Sign to Speak",
                    subtitle: "Turning gestures into conversations!",
                    page: const SpeakScreen(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF161622),
        selectedItemColor: const Color(0xFF66A3FF), 
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
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: "About"),
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
      height: 200,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A2456), 
            Color(0xFF161622),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        // optional soft glow
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66A3FF), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                fontSize: 13,
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

  LinearGradient get _appBarGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1F2A44),
          Color(0xFF2A3E68),
          Color(0xFF3A4F85),
        ],
      );

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
      final sock = await Socket.connect('192.168.4.1', 80,
          timeout: const Duration(seconds: 2));
      await sock.close();

      try {
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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Wi-Fi Status",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: .6,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: _appBarGradient),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1F2A44),
                    Color(0xFF2A3E68),
                    Color(0xFF3A4F85),
                  ],
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: AnimatedAlphabetBackground(density: 0.8),
          ),
          Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Color(0xFF66A3FF))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Color(0xFFF2F5FF)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 12,
                              spreadRadius: 1,
                              offset: Offset(0, 6),
                            ),
                          ],
                          border: Border.all(color: Color(0x0F000000)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isConnected == true
                                      ? const [
                                          Color(0xFF2BD9C8),
                                          Color(0xFF59FFA8)
                                        ]
                                      : const [
                                          Color(0xFFFF8A8A),
                                          Color(0xFFFF5E5E)
                                        ],
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x33000000),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isConnected == true ? Icons.check : Icons.close,
                                size: 96,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              isConnected == true
                                  ? "Connected!"
                                  : "Disconnected!",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: const Color(0xFF1D1E25),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _checkConnection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66A3FF),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Refresh",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
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

// Animation of background, floating letters
class AnimatedAlphabetBackground extends StatefulWidget {
  final double density;
  final double speed;
  final double maxFontSize;

  const AnimatedAlphabetBackground({
    super.key,
    this.density = 1.2,
    this.speed = 1.0,
    this.maxFontSize = 45,
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..addListener(_tick);
    _controller.repeat();
    _particles = [];
  }

  void _ensureParticles(Size size) {
    if (size == _lastSize && _particles.isNotEmpty) return;
    _lastSize = size;
    final baseCount =
        ((size.width * size.height) / 12000).clamp(20, 90).toInt();
    final count = (baseCount * widget.density).clamp(10, 140).toInt();

    _particles = List.generate(count, (_) {
      final letter = String.fromCharCode(65 + _rand.nextInt(26)); // A-Z
      final pos = Offset(
        _rand.nextDouble() * size.width,
        _rand.nextDouble() * size.height,
      );

      final vx = (_rand.nextDouble() * 0.6 + 0.1) * (_rand.nextBool() ? 1 : -1);
      final vy = (_rand.nextDouble() * 0.6 + 0.1) * (_rand.nextBool() ? 1 : -1);
      final fontSize = (_rand.nextDouble() * (widget.maxFontSize - 12)) + 12;
      final angularVel =
          (_rand.nextDouble() * 0.6 + 0.2) * (_rand.nextBool() ? 1 : -1);
      final baseOpacity = 0.35 + _rand.nextDouble() * 0.5;

      return _LetterParticle(
        letter: letter,
        position: pos,
        velocity: Offset(vx, vy),
        angle: _rand.nextDouble() * math.pi * 2,
        angularVelocity: angularVel,
        fontSize: fontSize,
        baseOpacity: baseOpacity,
      );
    });
  }

  void _tick() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            _ensureParticles(size);
            final dt = (16.0 / 1000.0) * widget.speed;
            for (final p in _particles) {
              p.position += p.velocity * dt * 12;
              p.angle += p.angularVelocity * dt;

              if (p.position.dx < -40) {
                p.position = Offset(size.width + 40, p.position.dy);
              }
              if (p.position.dx > size.width + 40) {
                p.position = Offset(-40, p.position.dy);
              }
              if (p.position.dy < -40) {
                p.position = Offset(p.position.dx, size.height + 40);
              }
              if (p.position.dy > size.height + 40) {
                p.position = Offset(p.position.dx, -40);
              }
            }

            return CustomPaint(
              painter: _AlphabetPainter(
                particles: _particles,
                time: _controller.value,
              ),
              size: size,
            );
          },
        ),
      ),
    );
  }
}

class _LetterParticle {
  _LetterParticle({
    required this.letter,
    required this.position,
    required this.velocity,
    required this.angle,
    required this.angularVelocity,
    required this.fontSize,
    required this.baseOpacity,
  });

  final String letter;
  Offset position;
  Offset velocity;
  double angle;
  final double angularVelocity;
  final double fontSize;
  final double baseOpacity;
}

class _AlphabetPainter extends CustomPainter {
  _AlphabetPainter({
    required this.particles,
    required this.time,
  });

  final List<_LetterParticle> particles;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    const letterColor = Color(0xFF66A3FF);
    for (final p in particles) {
      final twinkle =
          0.7 + 0.3 * math.sin((time * 2 * math.pi) + p.fontSize * 0.3);
      final opacity = (p.baseOpacity * twinkle).clamp(0.15, 0.95);

      final tp = TextPainter(
        text: TextSpan(
          text: p.letter,
          style: GoogleFonts.poppins(
            fontSize: p.fontSize,
            fontWeight: FontWeight.w600,
            color: letterColor.withOpacity(opacity),
            shadows: const [
              Shadow(
                  blurRadius: 8,
                  color: Color(0x334D86FF),
                  offset: Offset(0, 0)),
              Shadow(
                  blurRadius: 14,
                  color: Color(0x22000000),
                  offset: Offset(0, 2)),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(p.position.dx, p.position.dy);
      canvas.rotate(p.angle);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _AlphabetPainter oldDelegate) {
    return true;
  }
}
