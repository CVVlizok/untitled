import 'package:untitled/core/models/health_news_article.dart';
import '../../interfaces/health_news_repository.dart';

/// UseCase: Получить новости о психологии
/// NewsAPI: GET /everything?q=психология OR стресс&language=ru
class GetPsychologyNews {
  final HealthNewsRepository _repository;

  GetPsychologyNews(this._repository);

  Future<List<HealthNewsArticle>> call() async {
    return _repository.getPsychologyNews();
  }
}



