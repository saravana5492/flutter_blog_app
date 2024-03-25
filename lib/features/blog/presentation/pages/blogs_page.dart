import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/utils/snack_bar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogsPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogsPage(),
      );
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  @override
  void initState() {
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
    super.initState();
  }

  void _navigateToAddBlogPage(BuildContext context) async {
    final result = await Navigator.push(context, AddNewBlogPage.route());
    if (result == true && context.mounted) {
      context.read<BlogBloc>().add(BlogFetchAllBlogs());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs"),
        actions: [
          IconButton(
            onPressed: () => _navigateToAddBlogPage(context),
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogFetchAllBlogsSuccess) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogListCard(
                    blog: blog,
                    index: index,
                  );
                },
              ),
            );
          }
          return const Center(
            child: Text("No Blogs found."),
          );
        },
      ),
    );
  }
}
