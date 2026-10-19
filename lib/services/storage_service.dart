import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/file_item.dart';

class StorageService {
  final SharedPreferences prefs;
  StorageService(this.prefs);

  static const _filesKey = 'files';

  List<FileItem> get files {
    final raw = prefs.getString(_filesKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).map((e) => FileItem.fromJson(e)).toList();
  }

  Future<void> _save(List<FileItem> list) async {
    await prefs.setString(_filesKey, jsonEncode(list.map((f) => f.toJson()).toList()));
  }

  Future<FileItem> addFile(File source, String category) async {
    final dir = await getApplicationDocumentsDirectory();
    final catDir = Directory('${dir.path}/files/$category');
    if (!await catDir.exists()) await catDir.create(recursive: true);
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final dest = File('${catDir.path}/${source.uri.pathSegments.last}');
    await source.copy(dest.path);
    final item = FileItem(
      id: id,
      name: source.uri.pathSegments.last,
      path: dest.path,
      category: category,
      addedAt: DateTime.now(),
    );
    final list = files..add(item);
    await _save(list);
    return item;
  }

  Future<void> deleteFile(FileItem item) async {
    final f = File(item.path);
    if (await f.exists()) await f.delete();
    final list = files..removeWhere((e) => e.id == item.id);
    await _save(list);
  }

  List<FileItem> byCategory(String cat) => files.where((f) => f.category == cat).toList();
}
