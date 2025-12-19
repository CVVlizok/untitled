import 'package:untitled/core/models/health_news_article.dart';
import '../../interfaces/health_news_repository.dart';

/// UseCase: Получить новости о сне
/// NewsAPI: GET /everything?q=сон OR бессонница&language=ru
class GetSleepNews {
  final HealthNewsRepository _repository;

  GetSleepNews(this._repository);

  Future<List<HealthNewsArticle>> call() async {
    return _repository.getSleepNews();
  }
}



