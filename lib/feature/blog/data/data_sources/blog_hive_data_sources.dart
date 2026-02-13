import 'package:clean_bloc_supabase/feature/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogHiveDataSources {
  void uploadLocalBlog({required List<BlogModel> blogs});
  List<BlogModel> getLocalBlogs();
}

class BlogHiveDataSourceImplementation implements BlogHiveDataSources {
  static const String _boxName = 'blogs';

  @override
  void uploadLocalBlog({required List<BlogModel> blogs}) {
    try {
      final box = Hive.box<Map>(_boxName);

      // Clear existing blogs
      box.clear();

      // Store each blog with its id as key
      for (var blog in blogs) {
        box.put(blog.id, blog.toJson());
      }
    } catch (e) {
      throw Exception('Failed to upload blogs to local storage: $e');
    }
  }

  @override
  List<BlogModel> getLocalBlogs() {
    try {
      final box = Hive.box<Map>(_boxName);

      if (box.isEmpty) {
        return [];
      }

      return box.values.map((blogData) {
        final blogs = Map<String, dynamic>.from(blogData);
        return BlogModel.fromJson(blogs);
      }).toList();
    } catch (e) {
      throw Exception('Failed to retrieve blogs from local storage: $e');
    }
  }
}
