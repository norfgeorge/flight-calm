import 'package:flutter/material.dart';
import 'sos_screen.dart';

class BeforeYouFlyScreen extends StatefulWidget {
  final VoidCallback onExploreFlight;

  const BeforeYouFlyScreen({Key? key, required this.onExploreFlight}) : super(key: key);

  @override
  State<BeforeYouFlyScreen> createState() => _BeforeYouFlyScreenState();
}

class _BeforeYouFlyScreenState extends State<BeforeYouFlyScreen> {
  bool _chkStages = true;
  bool _chkAudio = false;
  bool _chkOffline = true;

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
              // Back Button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  children: const [
                    Icon(Icons.chevron_left, size: 22, color: Color(0xFF475569)),
                    SizedBox(width: 4),
                    Text(
                      'Before you fly',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'A little preparation.\nMore room to breathe.',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'serif',
                  color: Color(0xFF0F172A),
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 16),

              // Hero Illustration: Boarding Pass on Tray Table
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFFF1F5F9),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/img/hero_before_tray.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.airplane_ticket_outlined, size: 48, color: Color(0xFF0284C7)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Synced Flight Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('TAROM RO391 • B738', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                        SizedBox(height: 2),
                        Text('Bucharest (OTP) → Paris (CDG) • Seat 14B', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                    const Icon(Icons.check_circle, color: Color(0xFF38BDF8), size: 18),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'YOUR FLIGHT CHECKLIST',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.1, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: ListView(
                  children: [
                    _buildChecklistTile('Explore the stages of flight', _chkStages, (v) => setState(() => _chkStages = v!)),
                    _buildChecklistTile('Choose something to listen to', _chkAudio, (v) => setState(() => _chkAudio = v!)),
                    _buildChecklistTile('Save your guide offline (<15 MB)', _chkOffline, (v) => setState(() => _chkOffline = v!)),
                  ],
                ),
              ),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.onExploreFlight,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Explore your flight', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 10),

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

  Widget _buildChecklistTile(String text, bool value, ValueChanged<bool?> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: const Color(0xFF0284C7),
            onChanged: onChanged,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
        ],
      ),
    );
  }
}
