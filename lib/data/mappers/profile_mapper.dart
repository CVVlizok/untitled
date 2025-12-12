import 'package:untitled/core/models/profile.dart';
import '../dto/profile_dto.dart';

extension ProfileDtoMapper on ProfileDto {
  Profile toModel() {
    return Profile(
      id: id,
      name: name,
      login: login,
    );
  }
}

extension ProfileMapper on Profile {
  ProfileDto toDto() {
    return ProfileDto(
      id: id,
      name: name,
      login: login,
    );
  }
}



