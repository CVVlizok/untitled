import 'package:json_annotation/json_annotation.dart';

part 'work_dto.g.dart';

@JsonSerializable()
class WorkDto {
  final String? id;
  final String? doi;
  final String? title;
  @JsonKey(name: 'display_name')
  final String? displayName;
  @JsonKey(name: 'publication_year')
  final int? publicationYear;
  @JsonKey(name: 'publication_date')
  final String? publicationDate;
  @JsonKey(name: 'cited_by_count')
  final int? citedByCount;
  @JsonKey(name: 'primary_location')
  final PrimaryLocationDto? primaryLocation;
  @JsonKey(name: 'open_access')
  final OpenAccessDto? openAccess;
  @JsonKey(name: 'abstract_inverted_index')
  final Map<String, dynamic>? abstractInvertedIndex;

  const WorkDto({
    this.id,
    this.doi,
    this.title,
    this.displayName,
    this.publicationYear,
    this.publicationDate,
    this.citedByCount,
    this.primaryLocation,
    this.openAccess,
    this.abstractInvertedIndex,
  });

  factory WorkDto.fromJson(Map<String, dynamic> json) =>
      _$WorkDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkDtoToJson(this);
}

@JsonSerializable()
class PrimaryLocationDto {
  final SourceInfoDto? source;
  @JsonKey(name: 'landing_page_url')
  final String? landingPageUrl;
  @JsonKey(name: 'pdf_url')
  final String? pdfUrl;

  const PrimaryLocationDto({
    this.source,
    this.landingPageUrl,
    this.pdfUrl,
  });

  factory PrimaryLocationDto.fromJson(Map<String, dynamic> json) =>
      _$PrimaryLocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PrimaryLocationDtoToJson(this);
}

@JsonSerializable()
class SourceInfoDto {
  final String? id;
  @JsonKey(name: 'display_name')
  final String? displayName;
  @JsonKey(name: 'issn_l')
  final String? issnL;
  final String? type;

  const SourceInfoDto({
    this.id,
    this.displayName,
    this.issnL,
    this.type,
  });

  factory SourceInfoDto.fromJson(Map<String, dynamic> json) =>
      _$SourceInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SourceInfoDtoToJson(this);
}

@JsonSerializable()
class OpenAccessDto {
  @JsonKey(name: 'is_oa')
  final bool? isOa;
  @JsonKey(name: 'oa_status')
  final String? oaStatus;
  @JsonKey(name: 'oa_url')
  final String? oaUrl;

  const OpenAccessDto({
    this.isOa,
    this.oaStatus,
    this.oaUrl,
  });

  factory OpenAccessDto.fromJson(Map<String, dynamic> json) =>
      _$OpenAccessDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OpenAccessDtoToJson(this);
}



