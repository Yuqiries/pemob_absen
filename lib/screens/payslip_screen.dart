import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  String _username = "";
  int _upahHarian = 50000;
  int _totalMasuk = 5;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "";
      _upahHarian = prefs.getInt('upah') ?? 50000;
      // _totalMasuk bisa kamu update dari database attendance jika ada
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalGaji = _totalMasuk * _upahHarian;
    final String formattedGaji =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(totalGaji);
    final String bulanTahun = DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Slip Gaji"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: $_username", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text("Periode: $bulanTahun", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text("Total Hari Masuk: $_totalMasuk", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text("Upah Harian: Rp $_upahHarian", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              "Total Gaji: $formattedGaji",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
