import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/internet_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remoteDataSource;
  final BlogLocalDataSource localDataSource;
  BlogRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required String posterId,
    required String title,
    required String content,
    required File image,
    required List<String> topics,
  }) async {
    try {
      if (!await InternetChecker.isInternetConnected()) {
        left(Failure("No internet connection"));
      }

      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        updatedAt: DateTime.now(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
      );

      final imageUrl = await remoteDataSource.uploadBlogImage(
          image: image, blogId: blogModel.id);

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedBlog =
          await remoteDataSource.uploadBlog(blogModel: blogModel);

      return right(uploadedBlog);
    } on ServerException catch (err) {
      return left(Failure(err.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await InternetChecker.isInternetConnected()) {
        final localBlogs = localDataSource.getBlogsFromLocal();
        return right(localBlogs);
      }

      final blogs = await remoteDataSource.getAllBlogs();
      localDataSource.uploadBlogsToLocal(blogs);

      return right(blogs);
    } on ServerException catch (err) {
      return left(Failure(err.toString()));
    }
  }
}
