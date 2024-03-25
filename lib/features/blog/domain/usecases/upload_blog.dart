import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;
  UploadBlog({required this.blogRepository});

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      posterId: params.posterId,
      title: params.title,
      content: params.content,
      image: params.image,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String title;
  final String content;
  final File image;
  final List<String> topics;
  final String posterId;

  UploadBlogParams({
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
    required this.posterId,
  });
}
