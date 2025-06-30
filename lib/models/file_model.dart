class FileModel {
  final int? id;
  final String username;
  final String title;
  final String description;

  FileModel({
    this.id,
    required this.username,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'title': title,
      'description': description,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'],
      username: map['username'],
      title: map['title'],
      description: map['description'],
    );
  }
}
