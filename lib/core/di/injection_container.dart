import 'package:get_it/get_it.dart';

// Data Sources
import '../../data/datasources/measurements_local_data_source.dart';
import '../../data/datasources/notes_local_data_source.dart';
import '../../data/datasources/profile_local_data_source.dart';
import '../../data/datasources/water_local_data_source.dart';
import '../../data/datasources/mood_local_data_source.dart';
import '../../data/datasources/shared_prefs_data_source.dart';
import '../../data/datasources/auth_secure_data_source.dart';
import '../../data/database/database.dart';

// Repository Implementations
import '../../data/repositories/measurements_repository_impl.dart';
import '../../data/repositories/notes_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/water_repository_impl.dart';
import '../../data/repositories/mood_repository_impl.dart';

// Domain Interfaces
import '../../domain/interfaces/measurements_repository.dart';
import '../../domain/interfaces/notes_repository.dart';
import '../../domain/interfaces/profile_repository.dart';
import '../../domain/interfaces/water_repository.dart';
import '../../domain/interfaces/mood_repository.dart';

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

// BLoC/Cubit
import '../../ui/features/health/delegates/auth/login_form_cubit.dart';
import '../../ui/features/health/delegates/auth/register_form_cubit.dart';
import '../../ui/features/health/delegates/measurements/measurements_cubit.dart';
import '../../ui/features/health/delegates/notes/notes_cubit.dart';
import '../../ui/features/health/delegates/profile/profile_cubit.dart';
import '../../ui/features/health/delegates/water/water_cubit.dart';
import '../../ui/features/health/delegates/mood/mood_cubit.dart';
import '../../ui/features/health/delegates/settings/settings_cubit.dart';

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
}

