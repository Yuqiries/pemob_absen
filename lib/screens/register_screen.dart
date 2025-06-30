import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _usernameExists = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final db = DatabaseHelper.instance;
      final exists = await db.checkUsernameExists(_usernameController.text);
      if (exists) {
        setState(() {
          _usernameExists = true;
        });
      } else {
        UserModel user = UserModel(
          name: _nameController.text,
          username: _usernameController.text,
          password: _passwordController.text,
        );
        await db.insertUser(user);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi berhasil! Silakan login.")),
        );

        Navigator.pop(context); // kembali ke login
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_usernameExists)
                const Text("Username sudah digunakan.",
                    style: TextStyle(color: Colors.red)),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
                validator: (val) => val!.isEmpty ? "Masukkan nama" : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (val) => val!.isEmpty ? "Masukkan username" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (val) => val!.length < 4
                    ? "Password minimal 4 karakter"
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text("Daftar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
