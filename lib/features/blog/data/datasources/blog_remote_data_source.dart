import 'dart:io';
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog({
    required BlogModel blogModel,
  });
  Future<String> uploadBlogImage({
    required File image,
    required String blogId,
  });

  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<BlogModel> uploadBlog({required BlogModel blogModel}) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blogModel.toJson())
          .select();
      return BlogModel.fromMap(blogData.first);
    } catch (err) {
      throw ServerException(err.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required String blogId,
  }) async {
    try {
      await supabaseClient.storage.from("blog_images").upload(blogId, image);
      return supabaseClient.storage.from("blog_images").getPublicUrl(blogId);
    } catch (err) {
      throw ServerException(err.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final serverBlogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)')
          .order('updated_at');
      final blogModels = serverBlogs
          .map(
            (blog) => BlogModel.fromMap(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
      return blogModels;
    } catch (err) {
      throw ServerException(err.toString());
    }
  }
}
