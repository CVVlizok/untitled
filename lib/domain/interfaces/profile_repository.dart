import 'package:untitled/core/models/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
  Future<void> updateProfileName(String name);
  Future<void> updateProfileLogin(String login);
}



