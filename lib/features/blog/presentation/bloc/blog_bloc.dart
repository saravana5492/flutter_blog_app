import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((_, emit) => emit(BlogLoading()));
    on<BlogUpload>(_blogUpload);
    on<BlogFetchAllBlogs>(_blogFetchAllBlogs);
  }

  void _blogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(UploadBlogParams(
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
      posterId: event.posterId,
    ));
    res.fold(
      (failure) => emit(BlogFailure(message: failure.message)),
      (blog) => emit(BlogUploadSuccess()),
    );
  }

  void _blogFetchAllBlogs(
      BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (failure) => emit(BlogFailure(message: failure.message)),
      (blogs) => emit(BlogFetchAllBlogsSuccess(blogs: blogs)),
    );
  }
}
