import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _username = "";
  int _upahHarian = 50000;

  final _upahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAccountInfo();
  }

  Future<void> _loadAccountInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "";
      _upahHarian = prefs.getInt('upah') ?? 50000;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
        (route) => false,
      );
    }
  }

  Future<void> _showEditUpah() async {
    _upahController.text = _upahHarian.toString();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Upah Harian"),
        content: TextField(
          controller: _upahController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Upah Harian (Rp)"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('upah', int.parse(_upahController.text));
              Navigator.pop(context);
              _loadAccountInfo();
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _upahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Akun Saya")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Username: $_username"),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: Text("Upah Harian: Rp $_upahHarian"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _showEditUpah,
              ),
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
