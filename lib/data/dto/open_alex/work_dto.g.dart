// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkDto _$WorkDtoFromJson(Map<String, dynamic> json) => WorkDto(
      id: json['id'] as String?,
      doi: json['doi'] as String?,
      title: json['title'] as String?,
      displayName: json['display_name'] as String?,
      publicationYear: (json['publication_year'] as num?)?.toInt(),
      publicationDate: json['publication_date'] as String?,
      citedByCount: (json['cited_by_count'] as num?)?.toInt(),
      primaryLocation: json['primary_location'] == null
          ? null
          : PrimaryLocationDto.fromJson(
              json['primary_location'] as Map<String, dynamic>),
      openAccess: json['open_access'] == null
          ? null
          : OpenAccessDto.fromJson(json['open_access'] as Map<String, dynamic>),
      abstractInvertedIndex:
          json['abstract_inverted_index'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$WorkDtoToJson(WorkDto instance) => <String, dynamic>{
      'id': instance.id,
      'doi': instance.doi,
      'title': instance.title,
      'display_name': instance.displayName,
      'publication_year': instance.publicationYear,
      'publication_date': instance.publicationDate,
      'cited_by_count': instance.citedByCount,
      'primary_location': instance.primaryLocation,
      'open_access': instance.openAccess,
      'abstract_inverted_index': instance.abstractInvertedIndex,
    };

PrimaryLocationDto _$PrimaryLocationDtoFromJson(Map<String, dynamic> json) =>
    PrimaryLocationDto(
      source: json['source'] == null
          ? null
          : SourceInfoDto.fromJson(json['source'] as Map<String, dynamic>),
      landingPageUrl: json['landing_page_url'] as String?,
      pdfUrl: json['pdf_url'] as String?,
    );

Map<String, dynamic> _$PrimaryLocationDtoToJson(PrimaryLocationDto instance) =>
    <String, dynamic>{
      'source': instance.source,
      'landing_page_url': instance.landingPageUrl,
      'pdf_url': instance.pdfUrl,
    };

SourceInfoDto _$SourceInfoDtoFromJson(Map<String, dynamic> json) =>
    SourceInfoDto(
      id: json['id'] as String?,
      displayName: json['display_name'] as String?,
      issnL: json['issn_l'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$SourceInfoDtoToJson(SourceInfoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'issn_l': instance.issnL,
      'type': instance.type,
    };

OpenAccessDto _$OpenAccessDtoFromJson(Map<String, dynamic> json) =>
    OpenAccessDto(
      isOa: json['is_oa'] as bool?,
      oaStatus: json['oa_status'] as String?,
      oaUrl: json['oa_url'] as String?,
    );

Map<String, dynamic> _$OpenAccessDtoToJson(OpenAccessDto instance) =>
    <String, dynamic>{
      'is_oa': instance.isOa,
      'oa_status': instance.oaStatus,
      'oa_url': instance.oaUrl,
    };
