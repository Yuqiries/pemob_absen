class UserModel {
  final int? id;
  final String name;
  final String username;
  final String password;

  UserModel({
    this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  // Konversi dari objek ke Map (untuk insert ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
    };
  }

  // Konversi dari Map ke objek UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      password: map['password'],
    );
  }
}
