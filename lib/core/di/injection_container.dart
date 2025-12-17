import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Data Sources
import '../../data/datasources/measurements_local_data_source.dart';
import '../../data/datasources/notes_local_data_source.dart';
import '../../data/datasources/profile_local_data_source.dart';
import '../../data/datasources/water_local_data_source.dart';
import '../../data/datasources/mood_local_data_source.dart';
import '../../data/datasources/shared_prefs_data_source.dart';
import '../../data/datasources/auth_secure_data_source.dart';
import '../../data/database/database.dart';

// Network Layer
import '../network/dio_client.dart';
import '../../data/datasources/news_api_client.dart';
import '../../data/datasources/open_alex_api_client.dart';

// Repository Implementations
import '../../data/repositories/measurements_repository_impl.dart';
import '../../data/repositories/notes_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/water_repository_impl.dart';
import '../../data/repositories/mood_repository_impl.dart';
import '../../data/repositories/health_news_repository_impl.dart';
import '../../data/repositories/health_research_repository_impl.dart';

// Domain Interfaces
import '../../domain/interfaces/measurements_repository.dart';
import '../../domain/interfaces/notes_repository.dart';
import '../../domain/interfaces/profile_repository.dart';
import '../../domain/interfaces/water_repository.dart';
import '../../domain/interfaces/mood_repository.dart';
import '../../domain/interfaces/health_news_repository.dart';
import '../../domain/interfaces/health_research_repository.dart';

// Use Cases
import '../../domain/usecases/measurements/get_measurements.dart';
import '../../domain/usecases/measurements/get_measurements_by_type.dart';
import '../../domain/usecases/measurements/add_measurement.dart';
import '../../domain/usecases/measurements/remove_measurement.dart';
import '../../domain/usecases/notes/get_notes.dart';
import '../../domain/usecases/notes/add_note.dart';
import '../../domain/usecases/notes/remove_note.dart';
import '../../domain/usecases/profile/get_profile.dart';
import '../../domain/usecases/profile/update_profile_name.dart';
import '../../domain/usecases/profile/update_profile_login.dart';
import '../../domain/usecases/water/get_water_state.dart';
import '../../domain/usecases/water/get_water_history.dart';
import '../../domain/usecases/water/update_water_cups.dart';
import '../../domain/usecases/water/save_water_day.dart';
import '../../domain/usecases/water/update_water_target.dart';
import '../../domain/usecases/water/delete_water_log.dart';
import '../../domain/usecases/mood/get_mood_state.dart';
import '../../domain/usecases/mood/get_mood_history.dart';
import '../../domain/usecases/mood/select_mood.dart';
import '../../domain/usecases/mood/update_mood_note.dart';
import '../../domain/usecases/mood/save_mood_day.dart';
import '../../domain/usecases/mood/delete_mood_log.dart';
// Health News UseCases
import '../../domain/usecases/health_news/get_general_health_news.dart';
import '../../domain/usecases/health_news/get_psychology_news.dart';
import '../../domain/usecases/health_news/get_sleep_news.dart';
import '../../domain/usecases/health_news/get_nutrition_news.dart';
import '../../domain/usecases/health_news/search_health_news.dart';
// Health Research UseCases
import '../../domain/usecases/health_research/search_medicine_concepts.dart';
import '../../domain/usecases/health_research/search_public_health_concepts.dart';
import '../../domain/usecases/health_research/get_works_by_concept.dart';
import '../../domain/usecases/health_research/search_disease_works.dart';
import '../../domain/usecases/health_research/get_work_details.dart';

// BLoC/Cubit
import '../../ui/features/health/delegates/auth/login_form_cubit.dart';
import '../../ui/features/health/delegates/auth/register_form_cubit.dart';
import '../../ui/features/health/delegates/measurements/measurements_cubit.dart';
import '../../ui/features/health/delegates/notes/notes_cubit.dart';
import '../../ui/features/health/delegates/profile/profile_cubit.dart';
import '../../ui/features/health/delegates/water/water_cubit.dart';
import '../../ui/features/health/delegates/mood/mood_cubit.dart';
import '../../ui/features/health/delegates/settings/settings_cubit.dart';
import '../../ui/features/health/delegates/health_news/health_news_cubit.dart';
import '../../ui/features/health/delegates/health_research/health_research_cubit.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Data Sources (singleton)
  getIt.registerLazySingleton<SharedPrefsDataSource>(
    () => SharedPrefsDataSource(),
  );

  getIt.registerLazySingleton<AuthSecureDataSource>(
    () => AuthSecureDataSource(),
  );

  getIt.registerLazySingleton<AppDatabase>(
    () => AppDatabase(),
  );

  getIt.registerLazySingleton<MeasurementsLocalDataSource>(
    () => MeasurementsLocalDataSource(getIt<AppDatabase>()),
  );

  getIt.registerLazySingleton<NotesLocalDataSource>(
    () => NotesLocalDataSource(getIt<AppDatabase>()),
  );

  getIt.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSource(getIt<AppDatabase>()),
  );

  getIt.registerLazySingleton<WaterLocalDataSource>(
    () => WaterLocalDataSource(getIt<AppDatabase>()),
  );

  getIt.registerLazySingleton<MoodLocalDataSource>(
    () => MoodLocalDataSource(getIt<AppDatabase>()),
  );

  // Network Layer - Dio Clients
  getIt.registerLazySingleton<Dio>(
    () => DioClient.createNewsApiClient(),
    instanceName: 'newsApiDio',
  );

  getIt.registerLazySingleton<Dio>(
    () => DioClient.createOpenAlexClient(),
    instanceName: 'openAlexDio',
  );

  // Network Layer - API Clients
  getIt.registerLazySingleton<NewsApiClient>(
    () => NewsApiClient(getIt<Dio>(instanceName: 'newsApiDio')),
  );

  getIt.registerLazySingleton<OpenAlexApiClient>(
    () => OpenAlexApiClient(getIt<Dio>(instanceName: 'openAlexDio')),
  );

  // Repository Implementations (singleton)
  getIt.registerLazySingleton<MeasurementsRepository>(
    () => MeasurementsRepositoryImpl(
      getIt<MeasurementsLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(
      getIt<NotesLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      getIt<ProfileLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<WaterRepository>(
    () => WaterRepositoryImpl(
      getIt<WaterLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<MoodRepository>(
    () => MoodRepositoryImpl(
      getIt<MoodLocalDataSource>(),
    ),
  );

  // Network Repositories
  getIt.registerLazySingleton<HealthNewsRepository>(
    () => HealthNewsRepositoryImpl(getIt<NewsApiClient>()),
  );

  getIt.registerLazySingleton<HealthResearchRepository>(
    () => HealthResearchRepositoryImpl(getIt<OpenAlexApiClient>()),
  );

  // Use Cases (factory)
  getIt.registerFactory<GetMeasurements>(
    () => GetMeasurements(getIt<MeasurementsRepository>()),
  );

  getIt.registerFactory<GetMeasurementsByType>(
    () => GetMeasurementsByType(getIt<MeasurementsRepository>()),
  );

  getIt.registerFactory<AddMeasurement>(
    () => AddMeasurement(getIt<MeasurementsRepository>()),
  );

  getIt.registerFactory<RemoveMeasurement>(
    () => RemoveMeasurement(getIt<MeasurementsRepository>()),
  );

  getIt.registerFactory<GetNotes>(
    () => GetNotes(getIt<NotesRepository>()),
  );

  getIt.registerFactory<AddNote>(
    () => AddNote(getIt<NotesRepository>()),
  );

  getIt.registerFactory<RemoveNote>(
    () => RemoveNote(getIt<NotesRepository>()),
  );

  getIt.registerFactory<GetProfile>(
    () => GetProfile(getIt<ProfileRepository>()),
  );

  getIt.registerFactory<UpdateProfileName>(
    () => UpdateProfileName(getIt<ProfileRepository>()),
  );

  getIt.registerFactory<UpdateProfileLogin>(
    () => UpdateProfileLogin(getIt<ProfileRepository>()),
  );

  getIt.registerFactory<GetWaterState>(
    () => GetWaterState(getIt<WaterRepository>()),
  );

  getIt.registerFactory<GetWaterHistory>(
    () => GetWaterHistory(getIt<WaterRepository>()),
  );

  getIt.registerFactory<UpdateWaterCups>(
    () => UpdateWaterCups(getIt<WaterRepository>()),
  );

  getIt.registerFactory<SaveWaterDay>(
    () => SaveWaterDay(getIt<WaterRepository>()),
  );

  getIt.registerFactory<UpdateWaterTarget>(
    () => UpdateWaterTarget(getIt<WaterRepository>()),
  );

  getIt.registerFactory<DeleteWaterLog>(
    () => DeleteWaterLog(getIt<WaterRepository>()),
  );

  getIt.registerFactory<GetMoodState>(
    () => GetMoodState(getIt<MoodRepository>()),
  );

  getIt.registerFactory<GetMoodHistory>(
    () => GetMoodHistory(getIt<MoodRepository>()),
  );

  getIt.registerFactory<SelectMood>(
    () => SelectMood(getIt<MoodRepository>()),
  );

  getIt.registerFactory<UpdateMoodNote>(
    () => UpdateMoodNote(getIt<MoodRepository>()),
  );

  getIt.registerFactory<SaveMoodDay>(
    () => SaveMoodDay(getIt<MoodRepository>()),
  );

  getIt.registerFactory<DeleteMoodLog>(
    () => DeleteMoodLog(getIt<MoodRepository>()),
  );

  // Health News UseCases (5 запросов NewsAPI)
  getIt.registerFactory<GetGeneralHealthNews>(
    () => GetGeneralHealthNews(getIt<HealthNewsRepository>()),
  );

  getIt.registerFactory<GetPsychologyNews>(
    () => GetPsychologyNews(getIt<HealthNewsRepository>()),
  );

  getIt.registerFactory<GetSleepNews>(
    () => GetSleepNews(getIt<HealthNewsRepository>()),
  );

  getIt.registerFactory<GetNutritionNews>(
    () => GetNutritionNews(getIt<HealthNewsRepository>()),
  );

  getIt.registerFactory<SearchHealthNews>(
    () => SearchHealthNews(getIt<HealthNewsRepository>()),
  );

  // Health Research UseCases (5 запросов OpenAlex)
  getIt.registerFactory<SearchMedicineConcepts>(
    () => SearchMedicineConcepts(getIt<HealthResearchRepository>()),
  );

  getIt.registerFactory<SearchPublicHealthConcepts>(
    () => SearchPublicHealthConcepts(getIt<HealthResearchRepository>()),
  );

  getIt.registerFactory<GetWorksByConcept>(
    () => GetWorksByConcept(getIt<HealthResearchRepository>()),
  );

  getIt.registerFactory<SearchDiseaseWorks>(
    () => SearchDiseaseWorks(getIt<HealthResearchRepository>()),
  );

  getIt.registerFactory<GetWorkDetails>(
    () => GetWorkDetails(getIt<HealthResearchRepository>()),
  );

  // BLoC/Cubit (factory)
  getIt.registerFactory<LoginFormCubit>(
    () => LoginFormCubit(),
  );

  getIt.registerFactory<RegisterFormCubit>(
    () => RegisterFormCubit(),
  );

  getIt.registerFactory<MeasurementsCubit>(
    () => MeasurementsCubit(
      getIt<GetMeasurements>(),
      getIt<GetMeasurementsByType>(),
      getIt<AddMeasurement>(),
      getIt<RemoveMeasurement>(),
    ),
  );

  getIt.registerFactory<NotesCubit>(
    () => NotesCubit(
      getIt<GetNotes>(),
      getIt<AddNote>(),
      getIt<RemoveNote>(),
    ),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getIt<GetProfile>(),
      getIt<UpdateProfileName>(),
      getIt<UpdateProfileLogin>(),
    ),
  );

  getIt.registerFactory<WaterCubit>(
    () => WaterCubit(
      getIt<GetWaterState>(),
      getIt<GetWaterHistory>(),
      getIt<UpdateWaterCups>(),
      getIt<SaveWaterDay>(),
      getIt<UpdateWaterTarget>(),
      getIt<DeleteWaterLog>(),
    ),
  );

  getIt.registerFactory<MoodCubit>(
    () => MoodCubit(
      getIt<GetMoodState>(),
      getIt<GetMoodHistory>(),
      getIt<SelectMood>(),
      getIt<UpdateMoodNote>(),
      getIt<SaveMoodDay>(),
      getIt<DeleteMoodLog>(),
    ),
  );

  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(getIt<SharedPrefsDataSource>()),
  );

  // Health News Cubit
  getIt.registerFactory<HealthNewsCubit>(
    () => HealthNewsCubit(
      getIt<GetGeneralHealthNews>(),
      getIt<GetPsychologyNews>(),
      getIt<GetSleepNews>(),
      getIt<GetNutritionNews>(),
      getIt<SearchHealthNews>(),
    ),
  );

  // Health Research Cubit
  getIt.registerFactory<HealthResearchCubit>(
    () => HealthResearchCubit(
      getIt<SearchMedicineConcepts>(),
      getIt<SearchPublicHealthConcepts>(),
      getIt<GetWorksByConcept>(),
      getIt<SearchDiseaseWorks>(),
      getIt<GetWorkDetails>(),
    ),
  );
}

