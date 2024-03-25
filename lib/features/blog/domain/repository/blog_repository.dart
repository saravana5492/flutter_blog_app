import 'dart:io';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required String posterId,
    required String title,
    required String content,
    required File image,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
