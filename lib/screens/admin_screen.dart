import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../services/storage_service.dart';
import 'category_screen.dart';

class AdminScreen extends StatefulWidget {
  final SharedPreferences prefs;
  const AdminScreen({super.key, required this.prefs});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final storage = StorageService(widget.prefs);
    final all = storage.files;
    final counts = {
      'python': storage.byCategory('python').length,
      'javascript': storage.byCategory('javascript').length,
      'so': storage.byCategory('so').length,
      'telegram': storage.byCategory('telegram').length,
    };
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة المطور'), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('إحصائيات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: counts.entries.map((e) => Container(
              width: (MediaQuery.of(context).size.width - 52) / 2,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF26263A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.key.toUpperCase(), style: const TextStyle(color: kMuted, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text('${e.value}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kAccent2)),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 24),
          const Text('إدارة الأقسام', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...['python', 'javascript', 'so', 'telegram'].map((c) => Card(
            color: kCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: const Icon(Icons.folder, color: kAccent),
              title: Text(c.toUpperCase()),
              trailing: const Icon(Icons.chevron_right, color: kMuted),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => CategoryScreen(prefs: widget.prefs, category: c, title: c.toUpperCase()))),
            ),
          )),
          const SizedBox(height: 20),
          Text('${all.length} ملف مرفوع', style: const TextStyle(color: kMuted)),
        ],
      ),
    );
  }
}
