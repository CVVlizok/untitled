import 'package:untitled/core/models/scientific_health_article.dart';
import '../../interfaces/health_research_repository.dart';

/// UseCase: Получить научные статьи по концепту
/// OpenAlex: GET /works?filter=concept.id:<conceptId>&per-page=20
class GetWorksByConcept {
  final HealthResearchRepository _repository;

  GetWorksByConcept(this._repository);

  Future<List<ScientificHealthArticle>> call(String conceptId) async {
    return _repository.getWorksByConcept(conceptId);
  }
}

