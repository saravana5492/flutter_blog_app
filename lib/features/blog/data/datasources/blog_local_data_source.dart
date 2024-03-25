import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadBlogsToLocal(List<BlogModel> blogs);
  List<BlogModel> getBlogsFromLocal();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl({required this.box});

  @override
  List<BlogModel> getBlogsFromLocal() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (var i = 0; i < box.length; i++) {
        blogs.add(
          BlogModel.fromMap(
            box.get(i.toString()),
          ),
        );
      }
    });
    return blogs;
  }

  @override
  void uploadBlogsToLocal(List<BlogModel> blogs) {
    box.clear();

    box.write(() {
      for (var i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
