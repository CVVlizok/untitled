import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../dto/open_alex/concepts_response_dto.dart';
import '../dto/open_alex/works_response_dto.dart';
import '../dto/open_alex/work_dto.dart';

part 'open_alex_api_client.g.dart';

/// Retrofit клиент для OpenAlex API
/// Base URL: https://api.openalex.org
/// 
/// Реализует 5 разных запросов к API научных статей о здоровье
@RestApi()
abstract class OpenAlexApiClient {
  factory OpenAlexApiClient(Dio dio, {String baseUrl}) = _OpenAlexApiClient;

  /// 1. GET /concepts?search=medicine
  /// Поиск концептов по теме "медицина"
  @GET('/concepts')
  Future<ConceptsResponseDto> searchMedicineConcepts({
    @Query('search') String search = 'medicine',
    @Query('per-page') int perPage = 10,
  });

  /// 2. GET /concepts?search=public health
  /// Поиск концептов по теме "общественное здоровье"
  @GET('/concepts')
  Future<ConceptsResponseDto> searchPublicHealthConcepts({
    @Query('search') String search = 'public health',
    @Query('per-page') int perPage = 10,
  });

  /// 3. GET /works?filter=concept.id:<conceptId>&per-page=20
  /// Получить научные статьи по концепту (медицина)
  @GET('/works')
  Future<WorksResponseDto> getWorksByConcept({
    @Query('filter') required String filter,
    @Query('per-page') int perPage = 20,
  });

  /// 4. GET /works?search=diabetes OR cancer OR covid&filter=concept.id:<conceptId>
  /// Поиск научных статей по заболеваниям
  @GET('/works')
  Future<WorksResponseDto> searchDiseaseWorks({
    @Query('search') required String search,
    @Query('filter') String? filter,
    @Query('per-page') int perPage = 20,
  });

  /// 5. GET /works/{openAlexId}
  /// Детальная информация по выбранной статье
  @GET('/works/{id}')
  Future<WorkDto> getWorkDetails({
    @Path('id') required String id,
  });
}

