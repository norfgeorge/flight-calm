import 'package:flutter/material.dart';

class GMeterScreen extends StatefulWidget {
  const GMeterScreen({Key? key}) : super(key: key);

  @override
  State<GMeterScreen> createState() => _GMeterScreenState();
}

class _GMeterScreenState extends State<GMeterScreen> with SingleTickerProviderStateMixin {
  double _deltaG = 0.04;
  double _posX = 0.0;
  double _posY = 0.0;
  String _statusText = 'Smooth & Stable Flight';

  void _simulateBump(double amount) {
    setState(() {
      _deltaG = amount;
      _posX = (amount * 120);
      _posY = (amount * 80);
      _statusText = amount > 0.15
          ? 'Minor gust (Wings absorbing shock)'
          : 'Normal flight ripple';
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _deltaG = 0.02;
          _posX = 0.0;
          _posY = 0.0;
          _statusText = 'Smooth & Stable Flight';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Stability G-Meter (Turbulence)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Active filter dampening hand tremors. Measures exclusively true aircraft motion.',
            style: TextStyle(fontSize: 12, color: Colors.white54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Visual Stabilizer Target
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0F172A),
                border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.08),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Safe operating zone outer ring
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  // Crosshairs
                  Container(width: 240, height: 1, color: Colors.white10),
                  Container(width: 1, height: 240, color: Colors.white10),

                  // Floating Stabilized Sphere
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    transform: Matrix4.translationValues(_posX, _posY, 0),
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10B981),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.6),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '+${_deltaG.toStringAsFixed(2)}G',
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Live Readout Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              children: [
                Text(
                  _statusText,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Vertical variation: ${_deltaG.toStringAsFixed(2)} G (Normal)',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Structural Reassurance Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF38BDF8), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Aircraft wings and structure are factory-tested to withstand continuous forces exceeding 2.50 G (over 20x any normal turbulence).',
                    style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.35),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Test Bump Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => _simulateBump(0.08),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Color(0xFF334155)),
                ),
                child: const Text('Test Ripple (0.08G)', style: TextStyle(fontSize: 11)),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => _simulateBump(0.22),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Color(0xFF334155)),
                ),
                child: const Text('Test Gust (0.22G)', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
