import 'package:flutter/material.dart';

class AfterLandingScreen extends StatefulWidget {
  const AfterLandingScreen({Key? key}) : super(key: key);

  @override
  State<AfterLandingScreen> createState() => _AfterLandingScreenState();
}

class _AfterLandingScreenState extends State<AfterLandingScreen> {
  int _selectedPill = 1; // 0: Easier, 1: As expected, 2: Harder
  final TextEditingController _noteCtrl = TextEditingController();

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
              // Header
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  children: const [
                    Icon(Icons.chevron_left, size: 22, color: Color(0xFF475569)),
                    SizedBox(width: 4),
                    Text('After landing', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'You made space\nfor the journey.',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, fontFamily: 'serif', color: Color(0xFF0F172A), height: 1.15),
              ),

              const SizedBox(height: 16),

              // Hero illustration container
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/img/hero_landing_runway.png',
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 130,
                    color: const Color(0xFFF1F5F9),
                    child: const Center(child: Icon(Icons.flight_land, size: 48, color: Color(0xFF0284C7))),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text('How did the flight feel?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
              const SizedBox(height: 8),

              Row(
                children: [
                  _buildPill('Easier', 0),
                  const SizedBox(width: 8),
                  _buildPill('As expected', 1),
                  const SizedBox(width: 8),
                  _buildPill('Harder', 2),
                ],
              ),

              const SizedBox(height: 18),

              const Text('A note for next time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
              const SizedBox(height: 8),

              TextField(
                controller: _noteCtrl,
                maxLines: 3,
                style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'What helped you today?',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Your reflection has been safely saved on your device!')),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Save reflection', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Skip for now', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPill(String label, int index) {
    final active = _selectedPill == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPill = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFE0F2FE) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: active ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? const Color(0xFF0369A1) : const Color(0xFF475569),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
