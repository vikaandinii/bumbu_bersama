import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String phone = '';
  String birthDate = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  DateTime? selectedDate;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Tidak ada nama';
      email = prefs.getString('email') ?? 'Tidak ada email';
      phone = prefs.getString('phone') ?? 'Tidak ada nomor telepon';
      birthDate = prefs.getString('birthDate') ?? 'Tidak ada tanggal lahir';

      nameController.text = name;
      emailController.text = email;
      phoneController.text = phone;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString(
      'birthDate',
      selectedDate != null
          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
          : birthDate,
    );

    setState(() {
      name = nameController.text;
      email = emailController.text;
      phone = phoneController.text;
      birthDate =
          selectedDate != null
              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
              : birthDate;
      isEditing = false;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildProfileInfo() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(name),
            Divider(),
            Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(email),
            Divider(),
            Text('Telepon', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(phone),
            Divider(),
            Text(
              'Tanggal Lahir',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(birthDate),
          ],
        ),
      ),
    );
  }

  Widget _buildEditProfileForm() {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nama'),
        ),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(labelText: 'Telepon'),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                selectedDate == null
                    ? 'Tanggal Lahir: $birthDate'
                    : 'Tanggal Lahir: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              ),
            ),
            TextButton(
              onPressed: _pickDate,
              child: const Text('Pilih Tanggal'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Ini biar ke halaman home
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveProfile();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isEditing ? _buildEditProfileForm() : _buildProfileInfo(),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _logout, child: const Text('Logout')),
            ],
          ),
        ),
      ),
    );
  }
}
