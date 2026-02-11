import 'dart:io';
import 'package:clean_bloc_supabase/core/usecase/usecase.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/entities/blog.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/usecases/get_blog_by_id.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  // final GetBlogById _getBlogById;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    // required GetBlogById getBlogById,
  }) : _uploadBlog = uploadBlog,
       _getAllBlogs = getAllBlogs,
       //  _getBlogById = getBlogById,
       super(BlogInitial()) {
    on<BlogEvent>((event, emit) => BlogLoading());
    on<BlogUpload>(_onBlogUpload);
    on<FetchAllBlogs>(_onGetAllBlogs);
    // on<FetchBlogById>(_onGetBlogById);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParameters(
        posterId: event.posterId,
        image: event.image,
        title: event.title,
        content: event.content,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(error: l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onGetAllBlogs(FetchAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (l) => emit(BlogFailure(error: l.message)),
      (r) => emit(BlogDisplaySuccess(blogs: r)),
    );
  }

  // void _onGetBlogById(FetchBlogById event, Emitter<BlogState> emit) async {
  //   final res = await _getBlogById(GetBlogByIdParams(blogId: event.blogId));

  //   res.fold(
  //     (l) => emit(BlogFailure(error: l.message)),
  //     (r) => emit(BlogDetailSuccess(blog: r)),
  //   );
  // }
}
