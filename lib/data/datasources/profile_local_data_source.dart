import '../dto/profile_dto.dart';
import '../database/database.dart';
import 'package:drift/drift.dart';

class ProfileLocalDataSource {
  final AppDatabase _database;
  static const String _defaultProfileId = 'default';

  ProfileLocalDataSource(this._database);

  Future<ProfileDto> getProfile() async {
    try {
      var profile = await _database.getProfile();
      
      // Если профиля нет, создаем профиль по умолчанию
      if (profile == null) {
        await _database.insertProfile(
          ProfilesCompanion.insert(
            id: _defaultProfileId,
            name: 'Имя пользователя',
            login: 'user@example.com',
          ),
        );
        profile = await _database.getProfileById(_defaultProfileId);
      }
      
      return ProfileDto(
        id: profile!.id,
        name: profile.name,
        login: profile.login,
      );
    } catch (e) {
      throw Exception('Ошибка получения профиля: $e');
    }
  }

  Future<void> updateProfileName(String name) async {
    try {
      final profile = await _database.getProfile();
      if (profile == null) {
        // Если профиля нет, создаем новый
        await _database.insertProfile(
          ProfilesCompanion.insert(
            id: _defaultProfileId,
            name: name,
            login: 'user@example.com',
          ),
        );
      } else {
        await _database.updateProfile(
          profile.id,
          ProfilesCompanion(name: Value(name)),
        );
      }
    } catch (e) {
      throw Exception('Ошибка обновления имени профиля: $e');
    }
  }

  Future<void> updateProfileLogin(String login) async {
    try {
      final profile = await _database.getProfile();
      if (profile == null) {
        // Если профиля нет, создаем новый
        await _database.insertProfile(
          ProfilesCompanion.insert(
            id: _defaultProfileId,
            name: 'Имя пользователя',
            login: login,
          ),
        );
      } else {
        await _database.updateProfile(
          profile.id,
          ProfilesCompanion(login: Value(login)),
        );
      }
    } catch (e) {
      throw Exception('Ошибка обновления логина профиля: $e');
    }
  }
}




