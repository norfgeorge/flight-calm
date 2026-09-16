import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'sos_screen.dart';

class FlightMapScreen extends StatefulWidget {
  final String flightNumber;
  final String origin;
  final String destination;
  final String aircraft;

  const FlightMapScreen({
    Key? key,
    this.flightNumber = 'RO391',
    this.origin = 'OTP (Bucharest)',
    this.destination = 'CDG (Paris)',
    this.aircraft = 'Boeing 737-800',
  }) : super(key: key);

  @override
  State<FlightMapScreen> createState() => _FlightMapScreenState();
}

class _FlightMapScreenState extends State<FlightMapScreen>
    with SingleTickerProviderStateMixin {
  int _activeMode = 0; // 0: Route Map, 1: Horizon, 2: Virtual Window
  double _flightProgress = 0.58; // 0.0 to 1.0 (58% default)
  bool _isPlaying = true;
  double _bankAngle = 0.0; // degrees
  late AnimationController _tickerController;

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _tickerController.addListener(() {
      if (_isPlaying && mounted) {
        setState(() {
          _flightProgress += 0.0003;
          if (_flightProgress > 1.0) _flightProgress = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _tickerController.dispose();
    super.dispose();
  }

  void _simulateBank(double targetAngle) {
    setState(() => _bankAngle = targetAngle);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _bankAngle = 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final altFt = _calculateAltitude(_flightProgress);
    final speedKmh = _calculateSpeed(_flightProgress);
    final remKm = (1520 * (1.0 - _flightProgress)).round();
    final remMinutes = (135 * (1.0 - _flightProgress)).round();
    final phaseInfo = _getPhaseInfo(_flightProgress);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Row(
                      children: const [
                        Icon(Icons.chevron_left, size: 22, color: Color(0xFF475569)),
                        SizedBox(width: 4),
                        Text(
                          'Your Live Flight',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBAE6FD)),
                    ),
                    child: Text(
                      '${widget.flightNumber} • FL370',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0369A1),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Mode Pills Selector (Route Map, Horizon, Virtual Window)
              Row(
                children: [
                  _buildModePill('Radar', 0, icon: Icons.map_outlined),
                  const SizedBox(width: 6),
                  _buildModePill('Horizon', 1, icon: Icons.explore_outlined),
                  const SizedBox(width: 6),
                  _buildModePill('Window', 2, icon: Icons.crop_portrait_outlined),
                ],
              ),

              const SizedBox(height: 12),

              // Main Dynamic Screen Content
              Expanded(
                child: ListView(
                  children: [
                    if (_activeMode == 0) ...[
                      _buildMovingMapCard(remKm, remMinutes, altFt, speedKmh),
                      const SizedBox(height: 10),
                      _buildSimulationControls(),
                      const SizedBox(height: 10),
                      _buildTelemetryGrid(phaseInfo, altFt, speedKmh),
                      const SizedBox(height: 10),
                      _buildPilotReassuranceCard(phaseInfo),
                    ] else if (_activeMode == 1) ...[
                      _buildHorizonView(),
                    ] else ...[
                      _buildVirtualWindowView(),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Persistent SOS Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SosScreen(groundingPrompts: []),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF38BDF8),
                          boxShadow: [
                            BoxShadow(color: Color(0xFF38BDF8), blurRadius: 6, spreadRadius: 1),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'I feel anxious',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
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

  Widget _buildModePill(String label, int modeIndex, {IconData? icon}) {
    final active = _activeMode == modeIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeMode = modeIndex),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: active ? Colors.white : const Color(0xFF475569)),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: active ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovingMapCard(int remKm, int remMin, int altFt, int speedKmh) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFFF0F9FF), Color(0xFFF8FAFC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Custom Painter for Route & Airplane
            CustomPaint(
              size: const Size(double.infinity, 250),
              painter: FlightCorridorPainter(progress: _flightProgress),
            ),

            // Top Telemetry Badges
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHudBadge('ALT', '$altFt ft', const Color(0xFF0369A1)),
                  _buildHudBadge('GS', '$speedKmh km/h', const Color(0xFF1E293B)),
                  _buildHudBadge('REM', '${remMin ~/ 60}h ${remMin % 60}m', const Color(0xFF059669)),
                ],
              ),
            ),

            // Bottom Status Strip
            Positioned(
              bottom: 8,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(radius: 4, backgroundColor: Color(0xFF10B981)),
                        SizedBox(width: 6),
                        Text(
                          'Smooth airway • 100% stable flight',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                        ),
                      ],
                    ),
                    Text(
                      '$remKm km to Paris',
                      style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHudBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(color: Color(0xFF94A3B8))),
            TextSpan(text: value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulationControls() {
    final pct = (_flightProgress * 100).round();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isPlaying = !_isPlaying),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isPlaying ? const Color(0xFF0284C7) : const Color(0xFF64748B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            _isPlaying ? 'Live' : 'Paused',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Flight Simulation', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                ],
              ),
              Text(
                '$pct% complete',
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              activeTrackColor: const Color(0xFF0284C7),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFF0284C7),
            ),
            child: Slider(
              value: _flightProgress,
              min: 0.0,
              max: 1.0,
              onChanged: (val) => setState(() => _flightProgress = val),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('0% OTP', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
              Text('50% VIE', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
              Text('100% CDG', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryGrid(Map<String, String> phase, int alt, int speed) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CURRENT PHASE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8))),
                const SizedBox(height: 2),
                Text(phase['title']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(phase['desc']!, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CABIN PRESSURE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8))),
                const SizedBox(height: 2),
                Text(phase['cabin']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0369A1))),
                const SizedBox(height: 2),
                const Text('Mountain altitude equivalent (Alpine calm)', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPilotReassuranceCard(Map<String, String> phase) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, size: 16, color: Color(0xFF0284C7)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Captain Alexandru Briefing:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0369A1)),
                ),
                const SizedBox(height: 3),
                Text(
                  phase['briefing']!,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizonView() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Artificial Horizon & Banking Angle',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, fontFamily: 'serif', color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Proof that the aircraft is stable even when your body feels otherwise.',
          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Round Artificial Horizon Gyro
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF94A3B8), width: 4),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: ClipOval(
            child: Transform.rotate(
              angle: _bankAngle * (math.pi / 180),
              child: Stack(
                children: [
                  // Sky half
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0284C7), Color(0xFF7DD3FC)],
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  // Ground half
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF854D0E), Color(0xFF713F12)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Center Horizon Line
                  const Center(
                    child: Divider(color: Colors.white, thickness: 2, height: 2),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Text(
                    'Bank: ${_bankAngle.abs().round()}° ${_bankAngle == 0 ? "(Wings Level & Stable)" : _bankAngle > 0 ? "(Right Turn)" : "(Left Turn)"}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                  ),
                  const Text('Stable', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'In normal turns, centrifugal force balances gravity just like on a carousel: liquids do not spill, and your body remains firmly in your seat.',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.35),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _simulateBank(-18),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Left Turn (18°)', style: TextStyle(fontSize: 11)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _simulateBank(18),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Right Turn (18°)', style: TextStyle(fontSize: 11)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVirtualWindowView() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Virtual Window • FL370',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, fontFamily: 'serif', color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        const Text(
          'A calming visual perspective for aisle and center seats.',
          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Realistic airplane window oval frame
        Container(
          width: 190,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(95),
            color: const Color(0xFFE2E8F0),
            border: Border.all(color: const Color(0xFF94A3B8), width: 6),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Stack(
              children: [
                // Deep blue sky gradient
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0284C7), Color(0xFF7DD3FC), Color(0xFFF0F9FF)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Soft drifting clouds below
                Positioned(
                  bottom: 20,
                  left: -20,
                  right: -20,
                  height: 90,
                  child: CustomPaint(painter: CalmCloudPainter()),
                ),
                // Wing extending outwards
                Positioned(
                  top: 90,
                  left: 30,
                  width: 170,
                  height: 80,
                  child: CustomPaint(painter: SteadyWingPainter()),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const Text(
            'The wings ride on dense air just as a boat floats on water. Even when invisible, at 840 km/h air molecules provide continuous, reassuring physical support.',
            style: TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  int _calculateAltitude(double progress) {
    if (progress < 0.15) {
      return (progress * (37000 / 0.15)).round();
    } else if (progress > 0.80) {
      final t = (progress - 0.80) / 0.20;
      return (37000 - t * 35000).round();
    }
    return 37000;
  }

  int _calculateSpeed(double progress) {
    if (progress < 0.15) {
      return (280 + progress * 3500).round();
    } else if (progress > 0.80) {
      final t = (progress - 0.80) / 0.20;
      return (840 - t * 580).round();
    }
    return 840;
  }

  Map<String, String> _getPhaseInfo(double progress) {
    if (progress < 0.15) {
      return {
        'title': 'Climb & Departure',
        'desc': 'Reducing takeoff thrust to continuous climb.',
        'cabin': '3,500 ft (Adapting)',
        'briefing': 'Engines have been set to standard climb thrust. It is completely normal to hear the sound quiet down now.',
      };
    } else if (progress > 0.80) {
      return {
        'title': 'Smooth Descent (Top of Descent)',
        'desc': 'Cabin pressure gently increasing.',
        'cabin': '4,200 ft (Descent)',
        'briefing': 'Beginning descent toward Paris. Swallow or chew gum to equalize ear pressure comfortably.',
      };
    }
    return {
      'title': 'Smooth Cruise',
      'desc': 'Level flight at FL370 in calm air.',
      'cabin': '7,200 ft (Stable)',
      'briefing': 'Following our approved airway corridor over Central Europe. Even with light bumps, vertical movement is under 3 meters.',
    };
  }
}

class FlightCorridorPainter extends CustomPainter {
  final double progress;

  FlightCorridorPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Airway curve from OTP (0.85, 0.75) to CDG (0.15, 0.35)
    final pStart = Offset(size.width * 0.85, size.height * 0.75);
    final pEnd = Offset(size.width * 0.15, size.height * 0.35);
    final pControl = Offset(size.width * 0.45, size.height * 0.50);

    // Calm weather zone circles
    final weatherPaint = Paint()..color = const Color(0xFF10B981).withOpacity(0.12);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.60), 30, weatherPaint);
    canvas.drawCircle(Offset(size.width * 0.38, size.height * 0.44), 35, weatherPaint);

    // Dashed airway corridor line
    final airwayPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(pStart.dx, pStart.dy)
      ..quadraticBezierTo(pControl.dx, pControl.dy, pEnd.dx, pEnd.dy);

    canvas.drawPath(path, airwayPaint);

    // Waypoints
    _drawWaypoint(canvas, pStart, 'OTP', isHub: true);
    _drawWaypoint(canvas, Offset(size.width * 0.62, size.height * 0.60), 'BUD');
    _drawWaypoint(canvas, Offset(size.width * 0.48, size.height * 0.52), 'VIE');
    _drawWaypoint(canvas, Offset(size.width * 0.34, size.height * 0.44), 'MUC');
    _drawWaypoint(canvas, pEnd, 'CDG', isHub: true);

    // Current Airplane Position along Bezier
    final t = progress.clamp(0.0, 1.0);
    final planeX = (1 - t) * (1 - t) * pStart.dx + 2 * (1 - t) * t * pControl.dx + t * t * pEnd.dx;
    final planeY = (1 - t) * (1 - t) * pStart.dy + 2 * (1 - t) * t * pControl.dy + t * t * pEnd.dy;

    // Beacon pulsing ring
    final beaconPaint = Paint()..color = const Color(0xFF38BDF8).withOpacity(0.4);
    canvas.drawCircle(Offset(planeX, planeY), 16, beaconPaint);

    // Airplane Dot & Heading
    final planePaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(Offset(planeX, planeY), 6, planePaint);
    canvas.drawCircle(Offset(planeX, planeY), 8, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
  }

  void _drawWaypoint(Canvas canvas, Offset offset, String label, {bool isHub = false}) {
    final dotPaint = Paint()..color = isHub ? const Color(0xFF0284C7) : const Color(0xFF64748B);
    canvas.drawCircle(offset, isHub ? 4.5 : 3.0, dotPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: isHub ? 10 : 8,
          fontWeight: isHub ? FontWeight.bold : FontWeight.w500,
          color: const Color(0xFF334155),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(offset.dx - textPainter.width / 2, offset.dy + 6));
  }

  @override
  bool shouldRepaint(covariant FlightCorridorPainter oldDelegate) => oldDelegate.progress != progress;
}

class CalmCloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.85);
    canvas.drawOval(Rect.fromLTWH(0, 20, 90, 50), paint);
    canvas.drawOval(Rect.fromLTWH(60, 10, 100, 60), paint);
    canvas.drawOval(Rect.fromLTWH(130, 25, 90, 45), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SteadyWingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wingPaint = Paint()..color = const Color(0xFFF1F5F9);
    final wingStroke = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width, size.height * 0.8)
      ..lineTo(0, size.height * 0.4)
      ..lineTo(size.width * 0.1, size.height * 0.2)
      ..lineTo(size.width, size.height * 0.6)
      ..close();

    canvas.drawPath(path, wingPaint);
    canvas.drawPath(path, wingStroke);

    // Cyan Winglet
    final winglet = Path()
      ..moveTo(0, size.height * 0.4)
      ..lineTo(size.width * 0.05, size.height * 0.05)
      ..lineTo(size.width * 0.1, size.height * 0.2)
      ..close();
    canvas.drawPath(winglet, Paint()..color = const Color(0xFF0284C7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
