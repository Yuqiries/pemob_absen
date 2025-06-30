import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'attendance_log_screen.dart';
import 'time_off_screen.dart';
import 'my_files_screen.dart';
import 'qr_scanner_screen.dart';
import 'payslip_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _username = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Home"), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Selamat datang, $_username 👋",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildMenuItem(Icons.fact_check, "Attendance Log", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AttendanceLogScreen()),
                  );
                }),
                _buildMenuItem(Icons.attach_money, "Payslip", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PayslipScreen()),
                  );
                }),
                _buildMenuItem(Icons.calendar_today, "Time Off", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TimeOffScreen()),
                  );
                }),
                _buildMenuItem(Icons.folder, "My Files", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyFilesScreen()),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 30),
            const Text(
              'Announcement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            _announcementItem('Penyesuaian Jam Operasional Selama Bulan Ramadhan', '25 Feb 2025'),
            _announcementItem('Surat Keputusan Direksi – Penandaan dan Ketentuan Baru', '25 Feb 2025'),
            _announcementItem('CLI Benefit Cycle and Repayment Date for 2025', '08 Jan 2025'),
          ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 169, 81, 69).withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFAC1500), size: 30),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

 Widget _announcementItem(String title, String date) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.campaign_outlined),
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Text(date, style: const TextStyle(fontSize: 12)),
      ),
    );
  }