import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:number_trivia_tutorial/core/network/network_info.dart';
import 'package:number_trivia_tutorial/core/utils/input_converter.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_tutorial/features/number_trivia/presentation/bloc/bloc.dart';


final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Features
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      concrete: serviceLocator(),
      random: serviceLocator(),
      inputConverter: serviceLocator(),
    )
  );

  serviceLocator.registerLazySingleton(
    () => GetConcreteNumberTrivia(repository: serviceLocator())
  );
  serviceLocator.registerLazySingleton(() => GetRandomNumberTrivia(repository: serviceLocator()));

  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: serviceLocator(),
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    )
  );

  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(httpClient: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );


  // Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );

  // Third Party
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());

}
