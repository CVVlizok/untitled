// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'works_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorksResponseDto _$WorksResponseDtoFromJson(Map<String, dynamic> json) =>
    WorksResponseDto(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => WorkDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : MetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorksResponseDtoToJson(WorksResponseDto instance) =>
    <String, dynamic>{
      'results': instance.results,
      'meta': instance.meta,
    };
