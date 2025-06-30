import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import 'attendance_log_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _scanned = false;

  void _handleScan(String qrData) async {
    if (_scanned) return;
    setState(() => _scanned = true);

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'Guest';

    final now = DateTime.now();
    final tanggal = DateFormat('dd MMMM yyyy', 'id_ID').format(now);
    final jam = DateFormat('HH:mm:ss').format(now);

    await DatabaseHelper.instance.insertAttendance(username, tanggal, jam);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AttendanceLogScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR")),
      body: MobileScanner(
        onDetect: (BarcodeCapture barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              _handleScan(code);
            }
          }
        },
      ),
    );
  }
}
