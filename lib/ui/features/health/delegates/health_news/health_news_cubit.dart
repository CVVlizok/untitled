import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/models/health_news_article.dart';
import 'package:untitled/core/network/exceptions/network_exceptions.dart';
import 'package:untitled/domain/usecases/health_news/get_general_health_news.dart';
import 'package:untitled/domain/usecases/health_news/get_psychology_news.dart';
import 'package:untitled/domain/usecases/health_news/get_sleep_news.dart';
import 'package:untitled/domain/usecases/health_news/get_nutrition_news.dart';
import 'package:untitled/domain/usecases/health_news/search_health_news.dart';

/// Тип запроса для переключения между категориями
enum NewsCategory {
  general,      // Общее здоровье
  psychology,   // Психология
  sleep,        // Сон
  nutrition,    // Питание
  search,       // Поиск
}

/// Состояние экрана новостей о здоровье
class HealthNewsState {
  final List<HealthNewsArticle> articles;
  final bool isLoading;
  final String? error;
  final NewsCategory category;
  final String searchQuery;

  const HealthNewsState({
    this.articles = const [],
    this.isLoading = false,
    this.error,
    this.category = NewsCategory.general,
    this.searchQuery = '',
  });

  HealthNewsState copyWith({
    List<HealthNewsArticle>? articles,
    bool? isLoading,
    String? error,
    NewsCategory? category,
    String? searchQuery,
  }) {
    return HealthNewsState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Cubit для управления экраном новостей о здоровье
class HealthNewsCubit extends Cubit<HealthNewsState> {
  final GetGeneralHealthNews _getGeneralHealthNews;
  final GetPsychologyNews _getPsychologyNews;
  final GetSleepNews _getSleepNews;
  final GetNutritionNews _getNutritionNews;
  final SearchHealthNews _searchHealthNews;

  HealthNewsCubit(
    this._getGeneralHealthNews,
    this._getPsychologyNews,
    this._getSleepNews,
    this._getNutritionNews,
    this._searchHealthNews,
  ) : super(const HealthNewsState());

  /// Загрузить данные в зависимости от категории
  Future<void> loadNews() async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      List<HealthNewsArticle> articles;
      
      switch (state.category) {
        case NewsCategory.general:
          articles = await _getGeneralHealthNews();
          break;
        case NewsCategory.psychology:
          articles = await _getPsychologyNews();
          break;
        case NewsCategory.sleep:
          articles = await _getSleepNews();
          break;
        case NewsCategory.nutrition:
          articles = await _getNutritionNews();
          break;
        case NewsCategory.search:
          if (state.searchQuery.isEmpty) {
            emit(state.copyWith(isLoading: false, articles: []));
            return;
          }
          articles = await _searchHealthNews(state.searchQuery);
          break;
      }
      
      emit(state.copyWith(articles: articles, isLoading: false));
    } catch (e) {
      final errorMessage = _mapError(e);
      emit(state.copyWith(isLoading: false, error: errorMessage));
    }
  }

  /// Изменить категорию
  void setCategory(NewsCategory category) {
    emit(state.copyWith(category: category));
    loadNews();
  }

  /// Изменить поисковый запрос
  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  /// Выполнить поиск
  void search() {
    emit(state.copyWith(category: NewsCategory.search));
    loadNews();
  }

  String _mapError(dynamic error) {
    if (error is NetworkException) {
      return error.message;
    }
    return 'Произошла ошибка: ${error.toString()}';
  }
}
