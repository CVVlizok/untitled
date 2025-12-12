class ProfileDto {
  final String id;
  final String name;
  final String login;

  const ProfileDto({
    required this.id,
    required this.name,
    required this.login,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'login': login,
    };
  }

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      id: json['id'] as String,
      name: json['name'] as String,
      login: json['login'] as String,
    );
  }
}




