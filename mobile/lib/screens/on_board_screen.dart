import 'package:flutter/material.dart';
import 'flight_map_screen.dart';
import 'sos_screen.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  int _activeSubtab = 0; // 0: Sensations, 1: G-Meter, 2: Timeline
  double _simulatedG = 0.02;

  final Map<int, bool> _expanded = {0: false, 1: false, 2: false};

  void _simulateBump(double val) {
    setState(() => _simulatedG = val);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _simulatedG = 0.02);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Subtabs
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Row(
                      children: const [
                        Icon(Icons.chevron_left, size: 22, color: Color(0xFF475569)),
                        SizedBox(width: 4),
                        Text('On board', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildSubtabBtn('Sensations', 0),
                      const SizedBox(width: 4),
                      _buildSubtabBtn('G-Meter', 1),
                      const SizedBox(width: 4),
                      _buildSubtabBtn('Timeline', 2),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const FlightMapScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFBAE6FD)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.map_outlined, size: 12, color: Color(0xFF0369A1)),
                              SizedBox(width: 4),
                              Text(
                                'Map',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0369A1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Expanded(
                child: _activeSubtab == 0
                    ? _buildSensationsView()
                    : _activeSubtab == 1
                        ? _buildGMeterView()
                        : _buildTimelineView(),
              ),

              // Persistent SOS
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SosScreen(groundingPrompts: [])));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF38BDF8))),
                      const SizedBox(width: 8),
                      const Text('I feel anxious', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtabBtn(String label, int index) {
    final active = _activeSubtab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeSubtab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: active ? Colors.white : const Color(0xFF475569)),
        ),
      ),
    );
  }

  Widget _buildSensationsView() {
    return ListView(
      children: [
        const Text(
          'Getting to know\ntakeoff.',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, fontFamily: 'serif', color: Color(0xFF0F172A), height: 1.15),
        ),
        const SizedBox(height: 4),
        const Text('Explore the sounds and sensations.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        const SizedBox(height: 14),

        // Hero image container
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFF1F5F9),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const Center(child: Icon(Icons.flight_takeoff, size: 44, color: Color(0xFF0284C7))),
        ),
        const SizedBox(height: 16),

        const Text('SOUNDS & SENSATIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.1, color: Color(0xFF64748B))),
        const SizedBox(height: 8),

        _buildAccordionTile(0, 'A rising engine sound', 'Before takeoff, pilots test engine power and set takeoff thrust. The engines roar as they push forward to generate lift. It is completely routine.'),
        _buildAccordionTile(1, 'A thud after liftoff', 'That reassuring mechanical clunk is the landing gear retracting securely into the aircraft belly. The wheels are locked safely for flight.'),
        _buildAccordionTile(2, 'Airbus "dog bark" on ground', 'The Power Transfer Unit (PTU) tests hydraulic pressure between systems. It sounds like a barking dog, proving redundant safety is 100% active.'),

        const SizedBox(height: 10),

        // Listen to audio bar
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: const [
              CircleAvatar(radius: 16, backgroundColor: Color(0xFF1E293B), child: Icon(Icons.play_arrow, size: 16, color: Colors.white)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Listen to the explanation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                    Text('Captain Alexandru • Flight deck audio', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Text('2:10', style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: Color(0xFF94A3B8))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccordionTile(int index, String title, String explanation) {
    final isExp = _expanded[index] ?? false;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
            trailing: Text(isExp ? '−' : '+', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            onTap: () => setState(() => _expanded[index] = !isExp),
          ),
          if (isExp)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(explanation, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.4)),
            ),
        ],
      ),
    );
  }

  Widget _buildGMeterView() {
    return Column(
      children: [
        const Text(
          'Turbulence\nLevel Meter.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, fontFamily: 'serif', color: Color(0xFF0F172A), height: 1.15),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        const Text('Active filter dampening hand tremors.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        const SizedBox(height: 20),

        // Visual Target
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFECFDF5),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4), width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(width: 130, height: 130, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)))),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 50,
                height: 50,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF10B981)),
                child: Center(
                  child: Text(
                    '+${_simulatedG.toStringAsFixed(2)}G',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const Text(
            'Aircraft wings and structure are engineered to withstand continuous structural forces exceeding 2.50 G (over 20x any ordinary turbulence).',
            style: TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.35),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(onPressed: () => _simulateBump(0.08), child: const Text('Light bump (0.08G)', style: TextStyle(fontSize: 11))),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () => _simulateBump(0.22), child: const Text('Wind gust (0.22G)', style: TextStyle(fontSize: 11))),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineView() {
    return ListView(
      children: [
        const Text(
          'Flight Stages\n& Barometer.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, fontFamily: 'serif', color: Color(0xFF0F172A), height: 1.15),
        ),
        const SizedBox(height: 4),
        const Text('Cabin pressure monitoring & Top of Descent.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Cabin Pressure: 7,200 ft', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
              SizedBox(height: 4),
              Text('The aircraft has reached cruising altitude. You will be alerted 25 minutes prior to descent to equalize ear pressure.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
        ),
      ],
    );
  }
}
