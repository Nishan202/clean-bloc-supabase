// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:clean_bloc_supabase/core/error/failures.dart';
import 'package:clean_bloc_supabase/core/usecase/usecase.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/entities/blog.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/repository/blog_repository.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParameters> {
  BlogRepository blogRepository;
  UploadBlog({required this.blogRepository});
  @override
  Future<Either<Failures, Blog>> call(UploadBlogParameters params) async {
    return await blogRepository.uploadBlog(
      posterId: params.posterId,
      image: params.image,
      title: params.title,
      content: params.content,
      topics: params.topics,
    );
  }
}

class UploadBlogParameters {
  final String posterId;
  final File image;
  final String title;
  final String content;
  final List<String> topics;

  UploadBlogParameters({
    required this.posterId,
    required this.image,
    required this.title,
    required this.content,
    required this.topics,
  });
}
