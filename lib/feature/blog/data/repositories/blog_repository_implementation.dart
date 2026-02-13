// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:clean_bloc_supabase/core/error/exception.dart';
import 'package:clean_bloc_supabase/core/network/connection_checker.dart';
import 'package:clean_bloc_supabase/feature/blog/data/data_sources/blog_hive_data_sources.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import 'package:clean_bloc_supabase/core/error/failures.dart';
import 'package:clean_bloc_supabase/feature/blog/data/data_sources/blog_supabase_data_sources.dart';
import 'package:clean_bloc_supabase/feature/blog/data/models/blog_model.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/entities/blog.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/repository/blog_repository.dart';

class BlogRepositoryImplementation implements BlogRepository {
  final BlogSupabaseDataSources blogSupabaseDataSources;
  final BlogHiveDataSources blogHiveDataSources;
  final ConnectionChecker internetConnectionChecker;
  BlogRepositoryImplementation({
    required this.blogSupabaseDataSources,
    required this.blogHiveDataSources,
    required this.internetConnectionChecker,
  });

  @override
  Future<Either<Failures, Blog>> uploadBlog({
    required String posterId,
    required File image,
    required String title,
    required String content,
    required List<String> topics,
  }) async {
    try {
      if (!await internetConnectionChecker.isConnected) {
        return left(
          Failures('No internet connection. Please try again later.'),
        );
      }
      BlogModel blogModel = BlogModel(
        id: Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogSupabaseDataSources.uploadBlogImage(
        blogModel: blogModel,
        image: image,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await blogSupabaseDataSources.addBlog(
        blogModel: blogModel,
      );

      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, List<Blog>>> getAllBlogs() async {
    try {
      if (!await internetConnectionChecker.isConnected) {
        final blogs = blogHiveDataSources.getLocalBlogs();
        // if (blogs.isEmpty) {
        //   return left(
        //     Failures('No internet connection and no local data available.'),
        //   );
        // }
        return right(blogs);
      }
      final blogs = await blogSupabaseDataSources.getBlogs();
      blogHiveDataSources.uploadLocalBlog(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  // @override
  // Future<Either<Failures, Blog>> getBlogById({required String blogId}) async {
  //   try {
  //     final blog = await blogSupabaseDataSources.getBlogById(blogId: blogId);
  //     return right(blog);
  //   } on ServerException catch (e) {
  //     return left(Failures(e.message));
  //   }
  // }
}
