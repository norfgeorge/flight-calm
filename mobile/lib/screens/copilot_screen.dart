import 'package:flutter/material.dart';
import '../models/flight_bundle.dart';

class CopilotScreen extends StatefulWidget {
  final PreFlightBundleData? bundle;
  final Function(PanicScenarioItem) onPanicTap;

  const CopilotScreen({
    Key? key,
    required this.bundle,
    required this.onPanicTap,
  }) : super(key: key);

  @override
  State<CopilotScreen> createState() => _CopilotScreenState();
}

class _CopilotScreenState extends State<CopilotScreen> {
  String _selectedCategory = 'all'; // 'all', 'turb', 'thrust', 'safety'

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedCategory == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = value;
        });
      },
      selectedColor: const Color(0xFF0284C7),
      backgroundColor: const Color(0xFF0F172A),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: isSelected ? Colors.white : Colors.white70,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF1E293B),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bundle == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.airplane_ticket_outlined, size: 64, color: Colors.blueGrey),
            const SizedBox(height: 16),
            const Text(
              'No active flight synced',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan your boarding pass at the gate to sync flight data.',
              style: TextStyle(fontSize: 13, color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final b = widget.bundle!;

    final filteredScenarios = b.panicScenarios.where((item) {
      if (_selectedCategory == 'all') return true;
      if (_selectedCategory == 'turb') return item.category == 'turbulence';
      if (_selectedCategory == 'thrust') return item.category == 'thrust' || item.category == 'bank_angle';
      if (_selectedCategory == 'safety') {
        return item.category == 'safety' ||
            item.category == 'lights' ||
            item.category == 'pressure' ||
            item.category == 'noises';
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flight Hero Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(
                      '${b.carrierName} ${b.iataTicket.flightNumber}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${b.scheduledDurationMinutes} min',
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.origin.iata, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                        Text(b.origin.city, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                    const Icon(Icons.flight_takeoff, color: Colors.white70, size: 28),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(b.destination.iata, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                        Text(b.destination.city, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white24),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Aircraft: ${b.aircraft.name}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    Text('Seat: ${b.iataTicket.seatNumber}', style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Panic Prompts Header
          const Text(
            'Quick Panic Clarifications',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap when feeling anxious for instant pilot reassurance:',
            style: TextStyle(fontSize: 12, color: Colors.white54),
          ),
          const SizedBox(height: 12),

          // Category Filter Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Turbulence', 'turb'),
                const SizedBox(width: 8),
                _buildFilterChip('Thrust & Turns', 'thrust'),
                const SizedBox(width: 8),
                _buildFilterChip('Safety & What-Ifs', 'safety'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Panic Buttons List
          ...filteredScenarios.map((q) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => widget.onPanicTap(q),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.help_outline, color: Color(0xFF38BDF8), size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          q.prompt,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          )),

          const SizedBox(height: 20),

          // Flight Phase Schedule
          const Text(
            'Flight Phases (Dead Reckoning)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          ...b.phases.map((phase) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${phase.startMinute}m',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phase.phase.toUpperCase(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        phase.pilotDescription,
                        style: const TextStyle(fontSize: 11, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${phase.expectedCabinAltitudeFt} ft',
                  style: const TextStyle(fontSize: 11, color: Colors.white38, fontFamily: 'monospace'),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
