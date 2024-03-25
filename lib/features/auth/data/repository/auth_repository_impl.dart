import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/internet_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      if (!await InternetChecker.isInternetConnected()) {
        final currentSession = remoteDataSource.currentUserSession;
        if (currentSession == null) {
          return left(Failure("User not logged in."));
        }
        final user = User(
          id: currentSession.user.id,
          name: '',
          email: currentSession.user.email ?? '',
        );
        return right(user);
      }

      final user = await remoteDataSource.getCurrentUser();
      if (user == null) {
        return left(Failure("User not logged in."));
      }
      return right(user);
    } on ServerException catch (err) {
      return left(Failure(err.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await InternetChecker.isInternetConnected()) {
        return left(Failure("No internet connection!"));
      }
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (err) {
      return left(Failure(err.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (!await InternetChecker.isInternetConnected()) {
        return left(Failure("No internet connection!"));
      }

      final user = await remoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (err) {
      return left(Failure(err.message));
    }
  }
}
