import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calc_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlogListCard extends StatelessWidget {
  const BlogListCard({
    super.key,
    required this.blog,
    required this.index,
  });

  final Blog blog;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(BlogViewerPage.route(blog));
      },
      child: Container(
        decoration: BoxDecoration(
          color: index % 3 == 0
              ? AppPallete.gradient3
              : index % 2 == 0
                  ? AppPallete.gradient2
                  : AppPallete.gradient1,
          borderRadius: BorderRadius.circular(8),
        ),
        height: 120,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Column(
              children: [
                CachedNetworkImage(
                  imageUrl: blog.imageUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 104.0,
                  height: 104.0,
                )
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    blog.content,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Text(
                    '${calculateReadingTime(blog.content)} min',
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
