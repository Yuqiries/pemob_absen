import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // arahkan ke login screen, bukan main.dart

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _username = "";
  final String _nama = "Kenza Nandita Rahma";
  final String _tglLahir = "25 Mei 2003";
  final String _jabatan = "Staff IT";
  final String _divisi = "Teknologi Informasi";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "";
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Akun Saya"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Username: $_username"),
            ),
            ListTile(
              leading: const Icon(Icons.badge),
              title: Text("Nama Lengkap: $_nama"),
            ),
            ListTile(
              leading: const Icon(Icons.cake),
              title: Text("Tanggal Lahir: $_tglLahir"),
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: Text("Jabatan: $_jabatan"),
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: Text("Divisi: $_divisi"),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
