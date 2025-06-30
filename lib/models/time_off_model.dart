class TimeOffModel {
  final int? id;
  final String username;
  final String date;
  final String reason;

  TimeOffModel({
    this.id,
    required this.username,
    required this.date,
    required this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'date': date,
      'reason': reason,
    };
  }

  factory TimeOffModel.fromMap(Map<String, dynamic> map) {
    return TimeOffModel(
      id: map['id'],
      username: map['username'],
      date: map['date'],
      reason: map['reason'],
    );
  }
}
