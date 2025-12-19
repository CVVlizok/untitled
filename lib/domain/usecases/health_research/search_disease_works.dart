import 'package:untitled/core/models/scientific_health_article.dart';
import '../../interfaces/health_research_repository.dart';

/// UseCase: Поиск научных статей по заболеваниям
/// OpenAlex: GET /works?search=diabetes OR cancer OR covid&filter=concept.id:<conceptId>
class SearchDiseaseWorks {
  final HealthResearchRepository _repository;

  SearchDiseaseWorks(this._repository);

  Future<List<ScientificHealthArticle>> call(String query, {String? conceptId}) async {
    return _repository.searchDiseaseWorks(query, conceptId: conceptId);
  }
}



