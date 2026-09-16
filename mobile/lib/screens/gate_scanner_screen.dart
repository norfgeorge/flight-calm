import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/flight_bundle.dart';
import '../services/iata_parser_service.dart';

class GateScannerScreen extends StatefulWidget {
  final Function(PreFlightBundleData) onFlightSynced;

  const GateScannerScreen({Key? key, required this.onFlightSynced}) : super(key: key);

  @override
  State<GateScannerScreen> createState() => _GateScannerScreenState();
}

class _GateScannerScreenState extends State<GateScannerScreen> {
  final TextEditingController _barcodeCtrl = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Backend API URL (for emulator / local development)
  final String _backendUrl = 'http://10.0.2.2:3050/api/v1/flight/sync'; // or http://localhost:3050

  Future<void> _processBarcode(String raw) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Instant on-device verification via IATA Resolution 792 parser
      final localTicket = IataParserService.decode(raw);

      // 2. Gate synchronization attempt
      try {
        final response = await http
            .post(
              Uri.parse('http://localhost:3050/api/v1/flight/sync'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'rawBarcode': raw}),
            )
            .timeout(const Duration(seconds: 4));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            final bundle = PreFlightBundleData.fromJson(data['bundle']);
            widget.onFlightSynced(bundle);
            return;
          }
        }
      } catch (_) {
        // Fallback to local default bundle if at gate with no cell data
      }

      // If backend was unreachable, build standard offline fallback bundle for localTicket
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Flight decoded offline: ${localTicket.flightNumber} (${localTicket.originAirport} ➔ ${localTicket.destinationAirport})'),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid IATA barcode: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadDemo(String flight) {
    if (flight == 'RO391') {
      _barcodeCtrl.text = 'M1POPESCU/ANDREI MR   E7XYZ89 OTPCDGRO 0391 258Y014B0042 147>5180M';
    } else if (flight == 'LH1420') {
      _barcodeCtrl.text = 'M1MULLER/HANS MR     E8ABC12 FRAOTPLH 1420 258Y008A0012 147>5180M';
    } else {
      _barcodeCtrl.text = 'M1IONESCU/MARIA MS   E9DEF34 OTPLHRW6 3001 258Y022F0078 147>5180M';
    }
    _processBarcode(_barcodeCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scan Boarding Pass',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Scan the PDF417 or Aztec barcode from your printed ticket or digital boarding pass.',
            style: TextStyle(fontSize: 12, color: Colors.white54),
          ),
          const SizedBox(height: 20),

          // Camera Viewfinder Box Mock
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.qr_code_scanner, size: 72, color: Color(0xFF38BDF8)),
                Positioned(
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Align barcode within this frame',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Or test with a sample boarding pass:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                backgroundColor: const Color(0xFF1E293B),
                label: const Text('TAROM RO391 (B738)', style: TextStyle(fontSize: 11, color: Colors.white)),
                onPressed: () => _loadDemo('RO391'),
              ),
              ActionChip(
                backgroundColor: const Color(0xFF1E293B),
                label: const Text('Lufthansa LH1420 (A321neo)', style: TextStyle(fontSize: 11, color: Colors.white)),
                onPressed: () => _loadDemo('LH1420'),
              ),
              ActionChip(
                backgroundColor: const Color(0xFF1E293B),
                label: const Text('Wizz Air W63001', style: TextStyle(fontSize: 11, color: Colors.white)),
                onPressed: () => _loadDemo('W63001'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          TextField(
            controller: _barcodeCtrl,
            style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Paste raw IATA barcode string...',
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 11),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
            ),
          ),

          const SizedBox(height: 12),

          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_errorMessage!, style: const TextStyle(color: Color(0xFFF43F5E), fontSize: 12)),
            ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _processBarcode(_barcodeCtrl.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Decode & Sync Flight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
