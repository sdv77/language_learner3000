class RoleChangeLog {
  final String userId;
  final String userName;
  final String changedBy;
  final String oldRole;
  final String newRole;
  final DateTime changeDate;

  RoleChangeLog({
    required this.userId,
    required this.userName,
    required this.changedBy,
    required this.oldRole,
    required this.newRole,
    required this.changeDate,
  });

  factory RoleChangeLog.fromMap(Map<String, dynamic> map) {
    return RoleChangeLog(
      userId: map['userId'],
      userName: map['userName'],
      changedBy: map['changedBy'],
      oldRole: map['oldRole'],
      newRole: map['newRole'],
      changeDate: DateTime.parse(map['changeDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'changedBy': changedBy,
      'oldRole': oldRole,
      'newRole': newRole,
      'changeDate': changeDate.toIso8601String(),
    };
  }
}