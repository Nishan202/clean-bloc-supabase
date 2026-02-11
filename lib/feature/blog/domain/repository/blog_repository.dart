import 'dart:io';

import 'package:clean_bloc_supabase/core/error/failures.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failures, Blog>> uploadBlog({
    required String posterId,
    required File image,
    required String title,
    required String content,
    required List<String> topics,
  });

  Future<Either<Failures, List<Blog>>> getAllBlogs();
  // Future<Either<Failures, Blog>> getBlogById({required String blogId});
}
