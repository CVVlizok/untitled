// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsResponseDto _$NewsResponseDtoFromJson(Map<String, dynamic> json) =>
    NewsResponseDto(
      status: json['status'] as String?,
      totalResults: (json['totalResults'] as num?)?.toInt(),
      articles: (json['articles'] as List<dynamic>?)
          ?.map((e) => ArticleDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewsResponseDtoToJson(NewsResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'totalResults': instance.totalResults,
      'articles': instance.articles,
    };
