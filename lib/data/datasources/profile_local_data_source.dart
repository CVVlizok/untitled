import '../dto/profile_dto.dart';

class ProfileLocalDataSource {
  ProfileDto _profile = const ProfileDto(
    id: 'default',
    name: 'Имя пользователя',
    login: 'user@example.com',
  );

  Future<ProfileDto> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _profile;
  }

  Future<void> updateProfileName(String name) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _profile = ProfileDto(
      id: _profile.id,
      name: name,
      login: _profile.login,
    );
  }

  Future<void> updateProfileLogin(String login) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _profile = ProfileDto(
      id: _profile.id,
      name: _profile.name,
      login: login,
    );
  }
}



