import 'dart:async';
import 'package:flutter/material.dart';

class SosScreen extends StatefulWidget {
  final List<String> groundingPrompts;

  const SosScreen({Key? key, required this.groundingPrompts}) : super(key: key);

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  Timer? _timer;
  int _secondsInPhase = 4;
  int _phaseIndex = 0;

  final List<String> _phaseTitles = ['Inhale', 'Hold', 'Exhale', 'Rest'];
  final List<String> _phaseHints = [
    'Breathe in gently through your nose as the pulse increases',
    'Hold comfortably without strain',
    'Exhale slowly through your mouth, relaxing your shoulders',
    'Brief rest before the next gentle cycle',
  ];

  bool _showGrounding = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsInPhase--;
        if (_secondsInPhase <= 0) {
          _phaseIndex = (_phaseIndex + 1) % _phaseTitles.length;
          _secondsInPhase = 4;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712), // Pitch dark for sensory relief
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'SOS Emergency Relief',
          style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(_showGrounding ? Icons.air : Icons.psychology, color: Colors.white70),
            tooltip: _showGrounding ? 'Breathing Mode' : '5-4-3-2-1 Grounding',
            onPressed: () {
              setState(() {
                _showGrounding = !_showGrounding;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: _showGrounding ? _buildGroundingView() : _buildBreathingView(),
    );
  }

  Widget _buildBreathingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'You can close your eyes',
          style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        const Text(
          'The phone gently pulses at each rhythm change.',
          style: TextStyle(fontSize: 12, color: Colors.white38),
        ),
        const SizedBox(height: 50),

        // Animated Breathing Sphere
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF38BDF8).withOpacity(0.35),
                    const Color(0xFF38BDF8).withOpacity(0.05),
                  ],
                ),
                border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.5), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withOpacity(0.25),
                    blurRadius: 35,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _phaseTitles[_phaseIndex],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$_secondsInPhase s',
                      style: const TextStyle(fontSize: 16, color: Color(0xFFBAE6FD), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 50),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            _phaseHints[_phaseIndex],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
          ),
        ),

        const SizedBox(height: 40),

        TextButton.icon(
          onPressed: () {
            setState(() {
              _showGrounding = true;
            });
          },
          icon: const Icon(Icons.touch_app, size: 16, color: Color(0xFF38BDF8)),
          label: const Text(
            'Open Grounding Technique (5-4-3-2-1)',
            style: TextStyle(color: Color(0xFF38BDF8), fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildGroundingView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '5-4-3-2-1 Grounding Protocol',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 6),
        const Text(
          'Gently guides your attention back to the physical cabin environment.',
          style: TextStyle(fontSize: 12, color: Colors.white54),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xFF0F172A),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Image.asset(
                'assets/img/hero_sos_window.png',
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...widget.groundingPrompts.asMap().entries.map((entry) {
          final idx = 5 - entry.key;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF38BDF8).withOpacity(0.2),
                  child: Text(
                    '$idx',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.35),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
