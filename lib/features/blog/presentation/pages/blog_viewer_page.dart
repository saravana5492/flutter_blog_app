import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calc_reading_time.dart';
import 'package:blog_app/core/utils/date_format.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) => MaterialPageRoute(
        builder: ((context) => BlogViewerPage(blog: blog)),
      );

  const BlogViewerPage({
    super.key,
    required this.blog,
  });

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'by ${blog.posterName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatDatebydMMMyyyy(blog.updatedAt)} | ${calculateReadingTime(blog.content)} min',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppPallete.whiteColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: blog.imageUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    blog.content,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
