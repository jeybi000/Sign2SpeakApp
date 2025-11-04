import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'home.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class SpeakScreen extends StatefulWidget {
  const SpeakScreen({super.key});

  @override
  State<SpeakScreen> createState() => _SpeakScreenState();
}

class _SpeakScreenState extends State<SpeakScreen> {
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _gesturesCtrl = TextEditingController();
  final TextEditingController _textToSpeakCtrl = TextEditingController();

  WebSocketChannel? _channel;
  final String esp32Ip = 'ws://192.168.4.1:80';
  String? _lastGesture;

  @override
  void initState() {
    super.initState();
    _initTts();
    _connectWebSocket();
  }

  Future<void> _initTts() async {
    await _tts.awaitSpeakCompletion(true);
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
  }

  void _connectWebSocket() {
    _channel?.sink.close(status.goingAway);
    try {
      _channel = WebSocketChannel.connect(Uri.parse(esp32Ip));
      _channel!.stream.listen(
        (message) async {
          final newData = message.toString().trim().toUpperCase();
          if (newData.isEmpty || !mounted) return;

          if (newData == "NONE" || newData == "IDLE") {
            _lastGesture = null;
            return;
          }

          if (_lastGesture != newData) {
            _lastGesture = newData;

            setState(() {
              _gesturesCtrl.text = newData;
            });

            try {
              await _tts.stop();
              await _tts.speak(newData);

              setState(() {
                if (_textToSpeakCtrl.text.isNotEmpty) {
                  _textToSpeakCtrl.text += ' ';
                }
                _textToSpeakCtrl.text += newData;
                _gesturesCtrl.clear();
              });
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Speech error: $e'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          }
        },
        onError: (error) => _retryConnection(),
        onDone: () => _retryConnection(),
        cancelOnError: true,
      );
    } catch (_) {
      _retryConnection();
    }
  }

  void _retryConnection() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) _connectWebSocket();
    });
  }

  @override
  void dispose() {
    _gesturesCtrl.dispose();
    _textToSpeakCtrl.dispose();
    _channel?.sink.close(status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111325),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button + header
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text("Sign2Speak+",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Text("Sign your words and hear them speak—real-time magic with every move!",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 70),

              // DATA LOGS CARD
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1976FF),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(14)),
                      ),
                      child: Center(
                        child: Text(
                          "Data Logs",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: _textToSpeakCtrl,
                        readOnly: true,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.black87, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 100),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1976FF),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(14)),
                      ),
                      child: Center(
                        child: Text(
                          "Collected Gestures",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _gesturesCtrl,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: "recognized letters here",
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.black87, fontSize: 30, height: 3),
                            ),
                          ),
                          const Icon(
                            Icons.volume_up,
                            color: Color(0xFF1976FF),
                            size: 26,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              Center(
                child: Text(
                  "Sign2Speak+",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
