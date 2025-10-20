import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'home.dart';

// Added for ESP32 WebSocket connection
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
          Colors.white,
          Color(0xFFF4F7FF),
        ],
      );

  LinearGradient get _buttonGradient => const LinearGradient(
        colors: [
          Color(0xFF418DFF),
          Color(0xFF5B9DFF),
        ],
      );

  @override
  void initState() {
    super.initState();
    _initTts();

    // Connect to ESP32 WebSocket on start
    _connectWebSocket();
  }

  Future<void> _initTts() async {
    await _tts.awaitSpeakCompletion(true);
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    try {
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.duckOthers,
        ],
      );
    } catch (_) {
      // iOS-only setting; ignore on other platforms
    }
  }

  // WebSocket connection
  void _connectWebSocket() {
    _channel?.sink.close(status.goingAway);

    try {
      _channel = WebSocketChannel.connect(Uri.parse(esp32Ip));
      _channel!.stream.listen(
        (message) async {
          final newData = message.toString().trim();
          if (newData.isEmpty) return;

          if (!mounted) return;

          setState(() {
            _gesturesCtrl.text += newData.toUpperCase();
            _gesturesCtrl.selection = TextSelection.fromPosition(
              TextPosition(offset: _gesturesCtrl.text.length),
            );
          });

          try {
            await _tts.stop();
            await _tts.speak(newData.toUpperCase());

            setState(() {
              if (_textToSpeakCtrl.text.isNotEmpty) {
                _textToSpeakCtrl.text += ' ';
              }
              _textToSpeakCtrl.text += newData.toUpperCase();
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
        },
        onError: (error) {
          _retryConnection();
        },
        onDone: () {
          _retryConnection();
        },
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

  Future<void> _speakCollected() async {
    final text = _gesturesCtrl.text.trim();
    if (text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Nothing to speak.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      await _tts.speak(text);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('TTS failed to start. Check volume / device audio.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
      body: Container(
        decoration: BoxDecoration(gradient: _backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.12),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text("Sign2Speak+",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text("Sign your words and hear them speak—real-time magic with every move!",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                Text("Data Logs",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: _cardGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    reverse: false,
                    child: TextField(
                      controller: _textToSpeakCtrl,
                      readOnly: true,
                      maxLines: null,
                      expands: false,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text("Gestures",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: _cardGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _gesturesCtrl,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            hintText: 'Recognized gesture text appears here…',
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.volume_up,
                      color: Color(0xFF5B9DFF),
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: _buttonGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _speakCollected,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Speech",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Text(
                    "Sign2Speak+",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
