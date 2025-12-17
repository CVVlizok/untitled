// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concept_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConceptDto _$ConceptDtoFromJson(Map<String, dynamic> json) => ConceptDto(
      id: json['id'] as String?,
      displayName: json['display_name'] as String?,
      description: json['description'] as String?,
      worksCount: (json['works_count'] as num?)?.toInt(),
      citedByCount: (json['cited_by_count'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConceptDtoToJson(ConceptDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'description': instance.description,
      'works_count': instance.worksCount,
      'cited_by_count': instance.citedByCount,
      'level': instance.level,
    };
