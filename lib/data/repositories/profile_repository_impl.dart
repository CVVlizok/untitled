import 'package:untitled/core/models/profile.dart';
import '../../domain/interfaces/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../mappers/profile_mapper.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Profile> getProfile() async {
    final dto = await _dataSource.getProfile();
    return dto.toModel();
  }

  @override
  Future<void> updateProfileName(String name) async {
    await _dataSource.updateProfileName(name);
  }

  @override
  Future<void> updateProfileLogin(String login) async {
    await _dataSource.updateProfileLogin(login);
  }
}

