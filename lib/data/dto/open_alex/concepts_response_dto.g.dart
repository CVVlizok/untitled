// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concepts_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConceptsResponseDto _$ConceptsResponseDtoFromJson(Map<String, dynamic> json) =>
    ConceptsResponseDto(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => ConceptDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : MetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConceptsResponseDtoToJson(
        ConceptsResponseDto instance) =>
    <String, dynamic>{
      'results': instance.results,
      'meta': instance.meta,
    };

MetaDto _$MetaDtoFromJson(Map<String, dynamic> json) => MetaDto(
      count: (json['count'] as num?)?.toInt(),
      dbResponseTimeMs: (json['db_response_time_ms'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MetaDtoToJson(MetaDto instance) => <String, dynamic>{
      'count': instance.count,
      'db_response_time_ms': instance.dbResponseTimeMs,
      'page': instance.page,
      'per_page': instance.perPage,
    };
