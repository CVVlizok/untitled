class Profile {
  final String id;
  final String name;
  final String login;

  const Profile({
    required this.id,
    required this.name,
    required this.login,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? login,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      login: login ?? this.login,
    );
  }
}




