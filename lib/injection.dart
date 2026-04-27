import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/datasources/remote/event_remote_datasource.dart';
import 'data/datasources/remote/guest_remote_datasource.dart';
import 'data/datasources/remote/qr_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/event_repository_impl.dart';
import 'data/repositories/guest_repository_impl.dart';
import 'data/repositories/qr_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/event_repository.dart';
import 'domain/repositories/guest_repository.dart';
import 'domain/repositories/qr_repository.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/events/events_bloc.dart';
import 'presentation/blocs/guests/guests_bloc.dart';
import 'presentation/blocs/scanner/scanner_bloc.dart';
import 'presentation/blocs/settings/settings_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = Supabase.instance.client;

  // ─── Datasources ───
  sl.registerLazySingleton(() => AuthRemoteDatasource(supabase));
  sl.registerLazySingleton(() => EventRemoteDatasource(supabase));
  sl.registerLazySingleton(() => GuestRemoteDatasource(supabase));
  sl.registerLazySingleton(() => QrRemoteDatasource(supabase));

  // ─── Repositories ───
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDatasource>()));
  sl.registerLazySingleton<EventRepository>(
      () => EventRepositoryImpl(sl<EventRemoteDatasource>()));
  sl.registerLazySingleton<GuestRepository>(
      () => GuestRepositoryImpl(sl<GuestRemoteDatasource>()));
  sl.registerLazySingleton<QrRepository>(
      () => QrRepositoryImpl(sl<QrRemoteDatasource>()));

  // ─── BLoCs ───
  sl.registerFactory(() => AuthBloc(sl<AuthRepository>()));
  sl.registerFactory(() => EventsBloc(sl<EventRepository>()));
  sl.registerFactory(() => GuestsBloc(sl<GuestRepository>(), sl<EventRepository>()));
  sl.registerFactory(() => ScannerBloc(sl<QrRepository>()));
  sl.registerLazySingleton(() => SettingsCubit());
}
