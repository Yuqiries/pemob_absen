import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool scanned = false;
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  Future<void> _handleScan(String? code) async {
    if (scanned || code == null) return;

    setState(() => scanned = true);

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? "";

    if (code == "absensi-valid") {
      final now = DateTime.now();
      final date = DateFormat('yyyy-MM-dd').format(now);
      final time = DateFormat('HH:mm:ss').format(now);

      await DatabaseHelper.instance.insertAttendance(username, date, time);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Absensi berhasil!")),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ QR tidak valid.")),
        );
      }
    }

    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: MobileScanner(
        controller: controller,
        onDetect: (barcodeCapture) {
          final String? code = barcodeCapture.barcodes.first.rawValue;
          _handleScan(code);
        },
      ),
    );
  }
}
