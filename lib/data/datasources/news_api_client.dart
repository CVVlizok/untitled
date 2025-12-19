import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../dto/news_api/news_response_dto.dart';

part 'news_api_client.g.dart';

/// Retrofit клиент для NewsAPI
/// Base URL: https://newsapi.org/v2
/// 
/// Реализует 5 разных запросов к API новостей о здоровье
@RestApi()
abstract class NewsApiClient {
  factory NewsApiClient(Dio dio, {String baseUrl}) = _NewsApiClient;

  /// 1. GET /everything?q=здоровье OR медицина&language=ru
  /// Общие новости о здоровье
  @GET('/everything')
  Future<NewsResponseDto> getGeneralHealthNews({
    @Query('q') String query = 'здоровье OR медицина',
    @Query('language') String language = 'ru',
    @Query('sortBy') String sortBy = 'publishedAt',
    @Query('pageSize') int pageSize = 20,
  });

  /// 2. GET /everything?q=психология OR стресс OR ментальное&language=ru
  /// Новости о психологии и ментальном здоровье
  @GET('/everything')
  Future<NewsResponseDto> getPsychologyNews({
    @Query('q') String query = 'психология OR стресс OR тревожность',
    @Query('language') String language = 'ru',
    @Query('sortBy') String sortBy = 'publishedAt',
    @Query('pageSize') int pageSize = 20,
  });

  /// 3. GET /everything?q=сон OR бессонница OR отдых&language=ru
  /// Новости о сне и отдыхе
  @GET('/everything')
  Future<NewsResponseDto> getSleepNews({
    @Query('q') String query = 'сон OR бессонница OR отдых',
    @Query('language') String language = 'ru',
    @Query('sortBy') String sortBy = 'publishedAt',
    @Query('pageSize') int pageSize = 20,
  });

  /// 4. GET /everything?q=питание OR диета OR витамины&language=ru
  /// Новости о питании
  @GET('/everything')
  Future<NewsResponseDto> getNutritionNews({
    @Query('q') String query = 'питание OR диета OR витамины',
    @Query('language') String language = 'ru',
    @Query('sortBy') String sortBy = 'publishedAt',
    @Query('pageSize') int pageSize = 20,
  });

  /// 5. GET /everything?q=<user_query>&language=ru
  /// Поиск новостей по запросу пользователя
  @GET('/everything')
  Future<NewsResponseDto> searchHealthNews({
    @Query('q') required String query,
    @Query('language') String language = 'ru',
    @Query('sortBy') String sortBy = 'publishedAt',
    @Query('pageSize') int pageSize = 20,
  });
}
