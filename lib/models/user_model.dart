class UserModel {
  final String uid;
  final String email;
  final String role;
  final List<String> completedLessons;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.completedLessons,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'completedLessons': completedLessons,
    };
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'],
      role: data['role'],
      completedLessons: List<String>.from(data['completedLessons'] ?? []),
    );
  }
}