import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/models/scientific_health_article.dart';
import 'package:untitled/core/network/exceptions/network_exceptions.dart';
import 'package:untitled/domain/usecases/health_research/search_medicine_concepts.dart';
import 'package:untitled/domain/usecases/health_research/search_public_health_concepts.dart';
import 'package:untitled/domain/usecases/health_research/get_works_by_concept.dart';
import 'package:untitled/domain/usecases/health_research/search_disease_works.dart';
import 'package:untitled/domain/usecases/health_research/get_work_details.dart';

/// Тип запроса для переключения между разными API методами
enum ResearchRequestType {
  medicineConcepts,
  publicHealthConcepts,
  worksByConcept,
  searchDiseases,
  workDetails,
}

/// Состояние экрана научных статей
class HealthResearchState {
  final List<ScientificHealthArticle> articles;
  final List<HealthConcept> concepts;
  final ScientificHealthArticle? selectedArticle;
  final HealthConcept? selectedConcept;
  final bool isLoading;
  final String? error;
  final ResearchRequestType requestType;
  final String searchQuery;

  const HealthResearchState({
    this.articles = const [],
    this.concepts = const [],
    this.selectedArticle,
    this.selectedConcept,
    this.isLoading = false,
    this.error,
    this.requestType = ResearchRequestType.medicineConcepts,
    this.searchQuery = '',
  });

  HealthResearchState copyWith({
    List<ScientificHealthArticle>? articles,
    List<HealthConcept>? concepts,
    ScientificHealthArticle? selectedArticle,
    HealthConcept? selectedConcept,
    bool? isLoading,
    String? error,
    ResearchRequestType? requestType,
    String? searchQuery,
    bool clearSelectedArticle = false,
  }) {
    return HealthResearchState(
      articles: articles ?? this.articles,
      concepts: concepts ?? this.concepts,
      selectedArticle: clearSelectedArticle ? null : (selectedArticle ?? this.selectedArticle),
      selectedConcept: selectedConcept ?? this.selectedConcept,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      requestType: requestType ?? this.requestType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Cubit для управления экраном научных статей о здоровье
class HealthResearchCubit extends Cubit<HealthResearchState> {
  final SearchMedicineConcepts _searchMedicineConcepts;
  final SearchPublicHealthConcepts _searchPublicHealthConcepts;
  final GetWorksByConcept _getWorksByConcept;
  final SearchDiseaseWorks _searchDiseaseWorks;
  final GetWorkDetails _getWorkDetails;

  HealthResearchCubit(
    this._searchMedicineConcepts,
    this._searchPublicHealthConcepts,
    this._getWorksByConcept,
    this._searchDiseaseWorks,
    this._getWorkDetails,
  ) : super(const HealthResearchState());

  /// Загрузить данные в зависимости от типа запроса
  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      switch (state.requestType) {
        case ResearchRequestType.medicineConcepts:
          final concepts = await _searchMedicineConcepts();
          emit(state.copyWith(concepts: concepts, isLoading: false));
          break;
          
        case ResearchRequestType.publicHealthConcepts:
          final concepts = await _searchPublicHealthConcepts();
          emit(state.copyWith(concepts: concepts, isLoading: false));
          break;
          
        case ResearchRequestType.worksByConcept:
          if (state.selectedConcept != null) {
            final articles = await _getWorksByConcept(state.selectedConcept!.id);
            emit(state.copyWith(articles: articles, isLoading: false));
          } else {
            emit(state.copyWith(isLoading: false, error: 'Выберите концепт'));
          }
          break;
          
        case ResearchRequestType.searchDiseases:
          final query = state.searchQuery.isEmpty 
              ? 'diabetes OR cancer OR covid' 
              : state.searchQuery;
          final articles = await _searchDiseaseWorks(
            query,
            conceptId: state.selectedConcept?.id,
          );
          emit(state.copyWith(articles: articles, isLoading: false));
          break;
          
        case ResearchRequestType.workDetails:
          // Этот case обрабатывается отдельно через loadWorkDetails
          emit(state.copyWith(isLoading: false));
          break;
      }
    } catch (e) {
      final errorMessage = _mapError(e);
      emit(state.copyWith(isLoading: false, error: errorMessage));
    }
  }

  /// Загрузить концепты медицины
  Future<void> loadMedicineConcepts() async {
    emit(state.copyWith(requestType: ResearchRequestType.medicineConcepts));
    await loadData();
  }

  /// Загрузить концепты public health
  Future<void> loadPublicHealthConcepts() async {
    emit(state.copyWith(requestType: ResearchRequestType.publicHealthConcepts));
    await loadData();
  }

  /// Выбрать концепт и загрузить статьи
  Future<void> selectConceptAndLoadWorks(HealthConcept concept) async {
    emit(state.copyWith(
      selectedConcept: concept,
      requestType: ResearchRequestType.worksByConcept,
    ));
    await loadData();
  }

  /// Поиск по заболеваниям
  Future<void> searchDiseases(String query) async {
    emit(state.copyWith(
      searchQuery: query,
      requestType: ResearchRequestType.searchDiseases,
    ));
    await loadData();
  }

  /// Загрузить детали статьи
  Future<void> loadWorkDetails(String workId) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final article = await _getWorkDetails(workId);
      emit(state.copyWith(selectedArticle: article, isLoading: false));
    } catch (e) {
      final errorMessage = _mapError(e);
      emit(state.copyWith(isLoading: false, error: errorMessage));
    }
  }

  /// Очистить выбранную статью
  void clearSelectedArticle() {
    emit(state.copyWith(clearSelectedArticle: true));
  }

  /// Изменить поисковый запрос
  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  String _mapError(dynamic error) {
    if (error is NetworkException) {
      return error.message;
    }
    return 'Произошла ошибка: ${error.toString()}';
  }
}



