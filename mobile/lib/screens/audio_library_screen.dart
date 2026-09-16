import 'package:flutter/material.dart';
import 'sos_screen.dart';

class AudioLibraryScreen extends StatefulWidget {
  const AudioLibraryScreen({Key? key}) : super(key: key);

  @override
  State<AudioLibraryScreen> createState() => _AudioLibraryScreenState();
}

class _AudioLibraryScreenState extends State<AudioLibraryScreen> {
  int _activeCategory = 0; // 0: All, 1: Flight guides, 2: Calm
  String _currentTrack = 'A moment to reset';
  bool _isPlaying = false;

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
                    Text('Audio library', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Find something\nthat helps.',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, fontFamily: 'serif', color: Color(0xFF0F172A), height: 1.15),
              ),

              const SizedBox(height: 14),

              // Category Tabs
              Row(
                children: [
                  _buildTab('All', 0),
                  const SizedBox(width: 16),
                  _buildTab('Flight guides', 1),
                  const SizedBox(width: 16),
                  _buildTab('Calm', 2),
                ],
              ),
              const Divider(color: Color(0xFFE2E8F0)),

              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/img/hero_audio_clouds.png',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: [
                    _buildTrackTile('Understanding takeoff', '2 min', 'Captain Alexandru'),
                    _buildTrackTile('A moment to reset', '3 min', 'Guided calm'),
                    _buildTrackTile('Cabin sounds, explained', '4 min', 'PTU, gear & flaps'),
                  ],
                ),
              ),

              // Mini player bar
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isPlaying = !_isPlaying),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFF1E293B),
                        child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.between,
                            children: [
                              Text(_currentTrack, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                              const Text('0:00 / 3:00', style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: Color(0xFF94A3B8))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const LinearProgressIndicator(value: 0.25, backgroundColor: Color(0xFFF1F5F9), color: Color(0xFF38BDF8)),
                        ],
                      ),
                    ),
                  ],
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

  Widget _buildTab(String label, int index) {
    final active = _activeCategory == index;
    return GestureDetector(
      onTap: () => setState(() => _activeCategory = index),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: active ? FontWeight.bold : FontWeight.w500,
          color: active ? const Color(0xFF0284C7) : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildTrackTile(String title, String duration, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _currentTrack = title;
              _isPlaying = true;
            }),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF1E293B),
              child: Icon(Icons.play_arrow, size: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                Text('$duration • $subtitle', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          const Icon(Icons.download_done, color: Color(0xFF38BDF8), size: 18),
        ],
      ),
    );
  }
}
