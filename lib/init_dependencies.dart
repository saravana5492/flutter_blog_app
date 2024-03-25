import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signin.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signup.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repository/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnon,
  );

  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );

  // Core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'blogs'),
  );
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignup(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignin(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => CurrentUser(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignup: serviceLocator(),
      userSignin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBlog() {
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(
      supabaseClient: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<BlogLocalDataSource>(
    () => BlogLocalDataSourceImpl(
      box: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<BlogRepository>(
    () => BlogRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UploadBlog(
      blogRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetAllBlogs(
      blogRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => BlogBloc(
      uploadBlog: serviceLocator(),
      getAllBlogs: serviceLocator(),
    ),
  );
}
