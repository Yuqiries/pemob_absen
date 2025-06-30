import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';
import '../models/time_off_model.dart';

class TimeOffScreen extends StatefulWidget {
  const TimeOffScreen({super.key});

  @override
  State<TimeOffScreen> createState() => _TimeOffScreenState();
}

class _TimeOffScreenState extends State<TimeOffScreen> {
  List<TimeOffModel> _cutiList = [];
  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadCutiData();
  }

  Future<void> _loadCutiData() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? "";

    final data = await DatabaseHelper.instance.getTimeOffList(_username);
    setState(() {
      _cutiList = data;
    });
  }

  Future<void> _showForm({TimeOffModel? existing}) async {
    final dateController = TextEditingController(text: existing?.date);
    final reasonController = TextEditingController(text: existing?.reason);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Ajukan Cuti' : 'Edit Cuti'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Tanggal (yyyy-mm-dd)'),
            ),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Alasan cuti'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(existing == null ? "Simpan" : "Update"),
            onPressed: () async {
              if (dateController.text.isEmpty || reasonController.text.isEmpty) return;

              final cuti = TimeOffModel(
                id: existing?.id,
                username: _username,
                date: dateController.text,
                reason: reasonController.text,
              );

              if (existing == null) {
                await DatabaseHelper.instance.insertTimeOff(cuti);
              } else {
                await DatabaseHelper.instance.updateTimeOff(cuti);
              }

              Navigator.pop(context);
              _loadCutiData();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCuti(int id) async {
    await DatabaseHelper.instance.deleteTimeOff(id);
    _loadCutiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Time Off")),
      body: _cutiList.isEmpty
          ? const Center(child: Text("Belum ada permintaan cuti."))
          : ListView.builder(
              itemCount: _cutiList.length,
              itemBuilder: (context, index) {
                final cuti = _cutiList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text("Tanggal: ${cuti.date}"),
                    subtitle: Text("Alasan: ${cuti.reason}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _showForm(existing: cuti),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCuti(cuti.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
