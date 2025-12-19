import '../../interfaces/profile_repository.dart';

class UpdateProfileLogin {
  final ProfileRepository _repository;

  UpdateProfileLogin(this._repository);

  Future<void> call(String login) {
    return _repository.updateProfileLogin(login);
  }
}




