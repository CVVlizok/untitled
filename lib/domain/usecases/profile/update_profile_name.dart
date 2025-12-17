import '../../interfaces/profile_repository.dart';

class UpdateProfileName {
  final ProfileRepository _repository;

  UpdateProfileName(this._repository);

  Future<void> call(String name) {
    return _repository.updateProfileName(name);
  }
}







