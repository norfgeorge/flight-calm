import 'package:flutter/material.dart';
import 'before_you_fly_screen.dart';
import 'flight_map_screen.dart';
import 'on_board_screen.dart';
import 'after_landing_screen.dart';
import 'audio_library_screen.dart';
import 'sos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: fly calm + profile
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.flight, color: Color(0xFF0284C7), size: 22),
                      SizedBox(width: 8),
                      Text(
                        'fly calm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(Icons.person_outline, size: 16, color: Color(0xFF475569)),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Title Section
              const Text(
                'YOUR FLIGHT COMPANION',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Flying,\nat your pace.',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'serif',
                  color: Color(0xFF0F172A),
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'A little support for every part of your journey.',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),

              const SizedBox(height: 14),

              // Hero Illustration Card: Wing over clouds
              Container(
                height: 125,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBAE6FD), Color(0xFFF0F9FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/img/hero_home_wing.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        CustomPaint(painter: WingIllustrationPainter()),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Navigation Cards
              Expanded(
                child: ListView(
                  children: [
                    // FEATURED LIVE FLIGHT MAP CARD
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const FlightMapScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE0F2FE), Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: const Color(0xFFBAE6FD)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.between,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'In Flight • Live Radar',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'Open Flight Map →',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0284C7),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.between,
                                children: const [
                                  Text(
                                    'OTP (Bucharest)',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                  ),
                                  Text(
                                    'FL370 • 840 km/h',
                                    style: TextStyle(fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                                  ),
                                  Text(
                                    'CDG (Paris)',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildHubCard(
                      context,
                      icon: Icons.checklist,
                      title: 'Before you fly',
                      subtitle: 'Get familiar with the journey',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BeforeYouFlyScreen(
                              onExploreFlight: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const OnBoardScreen()),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildHubCard(
                      context,
                      icon: Icons.airplanemode_active,
                      title: 'On board',
                      subtitle: 'Know what to expect',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const OnBoardScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildHubCard(
                      context,
                      icon: Icons.headphones,
                      title: 'Audio library',
                      subtitle: 'Find something that helps',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const AudioLibraryScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildHubCard(
                      context,
                      icon: Icons.luggage_outlined,
                      title: 'After landing',
                      subtitle: 'Take a moment to reflect',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const AfterLandingScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Persistent Bottom Button: ● I feel anxious
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SosScreen(groundingPrompts: [])),
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
                        const SizedBox(width: 10),
                        const Text(
                          'I feel anxious',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHubCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: const Color(0xFF334155)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ),
    );
  }
}

class WingIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cloudPaint = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawOval(Rect.fromLTWH(-20, size.height - 35, size.width * 0.5, 50), cloudPaint);
    canvas.drawOval(Rect.fromLTWH(size.width * 0.3, size.height - 45, size.width * 0.8, 60), cloudPaint);

    final wingPaint = Paint()..color = const Color(0xFFF8FAFC);
    final wingStroke = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.8)
      ..lineTo(size.width * 0.75, size.height * 0.25)
      ..lineTo(size.width, size.height * 0.45)
      ..lineTo(size.width * 0.6, size.height)
      ..close();

    canvas.drawPath(path, wingPaint);
    canvas.drawPath(path, wingStroke);

    // Winglet tip
    final winglet = Path()
      ..moveTo(size.width * 0.75, size.height * 0.25)
      ..lineTo(size.width * 0.8, size.height * 0.08)
      ..lineTo(size.width * 0.83, size.height * 0.1)
      ..lineTo(size.width * 0.78, size.height * 0.28)
      ..close();
    canvas.drawPath(winglet, Paint()..color = const Color(0xFF38BDF8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
