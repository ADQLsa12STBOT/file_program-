import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../theme.dart';
import '../services/storage_service.dart';
import '../models/file_item.dart';

class CategoryScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final String category;
  final String title;
  const CategoryScreen({super.key, required this.prefs, required this.category, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late StorageService storage;

  @override
  void initState() {
    super.initState();
    storage = StorageService(widget.prefs);
  }

  Future<void> _add() async {
    final res = await FilePicker.platform.pickFiles();
    if (res == null || res.files.single.path == null) return;
    final f = File(res.files.single.path!);
    await storage.addFile(f, widget.category);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = storage.byCategory(widget.category);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.transparent),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        backgroundColor: kAccent,
        icon: const Icon(Icons.upload_file),
        label: const Text('رفع ملف'),
      ),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 70, color: kMuted),
                  SizedBox(height: 14),
                  Text('لا توجد ملفات بعد', style: TextStyle(color: kMuted)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final FileItem it = items[i];
                return Card(
                  color: kCard,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    leading: const Icon(Icons.insert_drive_file, color: kAccent2),
                    title: Text(it.name),
                    subtitle: Text(it.addedAt.toString().substring(0, 16), style: const TextStyle(color: kMuted)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () async {
                        await storage.deleteFile(it);
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
