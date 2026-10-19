class FileItem {
  final String id;
  final String name;
  final String path;
  final String category;
  final DateTime addedAt;

  FileItem({
    required this.id,
    required this.name,
    required this.path,
    required this.category,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'path': path,
        'category': category,
        'addedAt': addedAt.toIso8601String(),
      };

  factory FileItem.fromJson(Map<String, dynamic> j) => FileItem(
        id: j['id'],
        name: j['name'],
        path: j['path'],
        category: j['category'],
        addedAt: DateTime.parse(j['addedAt']),
      );
}
