import 'package:untitled/core/models/profile.dart';
import '../../interfaces/profile_repository.dart';

class GetProfile {
  final ProfileRepository _repository;

  GetProfile(this._repository);

  Future<Profile> call() {
    return _repository.getProfile();
  }
}




