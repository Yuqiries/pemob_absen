import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';
import '../models/file_model.dart';

class MyFilesScreen extends StatefulWidget {
  const MyFilesScreen({super.key});

  @override
  State<MyFilesScreen> createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends State<MyFilesScreen> {
  List<FileModel> _fileList = [];
  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? "";
    final data = await DatabaseHelper.instance.getFileList(_username);
    setState(() {
      _fileList = data;
    });
  }

  Future<void> _showFileForm({FileModel? existing}) async {
    final titleController = TextEditingController(text: existing?.title ?? "");
    final descController = TextEditingController(text: existing?.description ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Tambah File' : 'Edit File'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Nama File'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
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
              if (titleController.text.isEmpty || descController.text.isEmpty) return;

              final file = FileModel(
                id: existing?.id,
                username: _username,
                title: titleController.text,
                description: descController.text,
              );

              if (existing == null) {
                await DatabaseHelper.instance.insertFile(file);
              } else {
                await DatabaseHelper.instance.updateFile(file);
              }

              Navigator.pop(context);
              _loadFiles();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFile(int id) async {
    await DatabaseHelper.instance.deleteFile(id);
    _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Files")),
      body: _fileList.isEmpty
          ? const Center(child: Text("Belum ada file."))
          : ListView.builder(
              itemCount: _fileList.length,
              itemBuilder: (context, index) {
                final file = _fileList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
                    title: Text(file.title),
                    subtitle: Text(file.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _showFileForm(existing: file),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteFile(file.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFileForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
