import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';

class AttendanceLogScreen extends StatefulWidget {
  const AttendanceLogScreen({super.key});

  @override
  State<AttendanceLogScreen> createState() => _AttendanceLogScreenState();
}

class _AttendanceLogScreenState extends State<AttendanceLogScreen> {
  List<Map<String, dynamic>> _attendanceList = [];
  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? "";

    final data = await DatabaseHelper.instance.getAttendanceLog(username);

    setState(() {
      _username = username;
      _attendanceList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Kehadiran")),
      body: _attendanceList.isEmpty
          ? const Center(child: Text("Belum ada data absensi."))
          : ListView.builder(
              itemCount: _attendanceList.length,
              itemBuilder: (context, index) {
                final entry = _attendanceList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text("Tanggal: ${entry['date']}"),
                    subtitle: Text("Waktu: ${entry['time']}"),
                  ),
                );
              },
            ),
    );
  }
}
