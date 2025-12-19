import 'package:json_annotation/json_annotation.dart';
import 'article_dto.dart';

part 'news_response_dto.g.dart';

@JsonSerializable()
class NewsResponseDto {
  final String? status;
  final int? totalResults;
  final List<ArticleDto>? articles;

  const NewsResponseDto({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory NewsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseDtoToJson(this);
}



