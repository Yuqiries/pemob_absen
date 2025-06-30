import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'attendance_log_screen.dart';
import 'time_off_screen.dart';
import 'my_files_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = "";
  int _totalAbsensi = 0;
  int _upahHarian = 50000; // default, bisa disimpan ke SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadAbsensi();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "";
    });
  }

  Future<void> _loadAbsensi() async {
    // Simulasi jumlah masuk (harusnya ambil dari database)
    setState(() {
      _totalAbsensi = 5; // contoh: nanti diisi dari database
    });
  }

  @override
  Widget build(BuildContext context) {
    int gaji = _totalAbsensi * _upahHarian;

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Selamat datang, $_username 👋",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            _buildMenu(
              icon: Icons.fact_check,
              title: "Attendance Log",
              subtitle: "Lihat riwayat kehadiran",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AttendanceLogScreen(),
                  ),
                );
              },
            ),
            _buildMenu(
              icon: Icons.attach_money,
              title: "My Payslip",
              subtitle: "Total gaji: Rp $gaji",
              onTap: () {},
            ),
            _buildMenu(
              icon: Icons.calendar_today,
              title: "Time Off",
              subtitle: "Ajukan cuti",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TimeOffScreen()),
                );
              },
            ),
            _buildMenu(
              icon: Icons.folder,
              title: "My Files",
              subtitle: "Lihat berkas Anda",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyFilesScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
