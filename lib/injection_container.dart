import 'package:get_it/get_it.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/core/data/remote/dio_helper.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/login/data/remote_data_source/login_remote_datascoure.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/login/domain/repositiores_impl/login_repo.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/login/domain/usecase/login_usecase.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/login/presentation/cubit/login_cubit.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/singup/data/signup_remote_datascource/signup_remote_datasource.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/singup/data/signup_repository/signup_repository.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/singup/domain/sigup_usecase/dart/signup_usecase.dart';

import 'advanced_bloc/features/login/data/repositories/login_repo_impl.dart';
import 'advanced_bloc/features/singup/persentation/bloc/signup_bloc.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {

    sl.registerLazySingleton<DioHelper>(() => DioHelper());

    // Registering Login dependencies
    sl.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteSourceImpl());

    sl.registerLazySingleton<LoginRepo>(() => LoginRepoImpl(sl<LoginRemoteDataSource>()));

    sl.registerLazySingleton(() => LoginUseCase(sl<LoginRepoImpl>()));

    sl.registerFactory(() => LoginCubit(sl<LoginUseCase>()));

    // Registering Signup dependencies
    sl.registerLazySingleton<SignupRemoteDatasource>(() => SignupRemoteDatasourceImpl(sl<DioHelper>()));

    sl.registerLazySingleton<SignupRepository>(() => SignupRepositoryImpl(sl<SignupRemoteDatasource>()));

    sl.registerLazySingleton(() => SignupUseCase(sl<SignupRepository>()));

    sl.registerFactory(() => SignupBloc(sl<SignupUseCase>()));

  }
}