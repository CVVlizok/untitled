import 'package:untitled/core/models/scientific_health_article.dart';
import '../../interfaces/health_research_repository.dart';

/// UseCase: Детальная информация по статье
/// OpenAlex: GET /works/{openAlexId}
class GetWorkDetails {
  final HealthResearchRepository _repository;

  GetWorkDetails(this._repository);

  Future<ScientificHealthArticle> call(String workId) async {
    return _repository.getWorkDetails(workId);
  }
}



