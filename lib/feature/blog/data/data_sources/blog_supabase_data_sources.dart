import 'dart:io';

import 'package:clean_bloc_supabase/core/error/exception.dart';
import 'package:clean_bloc_supabase/feature/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogSupabaseDataSources {
  Future<BlogModel> addBlog({required BlogModel blogModel});
  Future<String> uploadBlogImage({
    required BlogModel blogModel,
    required File image,
  });
  Future<List<BlogModel>> getBlogs();
  // Future<BlogModel> getBlogById({required String blogId});
}

class BlogSupabaseDataSourceImplementation implements BlogSupabaseDataSources {
  final SupabaseClient supabaseClient;

  BlogSupabaseDataSourceImplementation({required this.supabaseClient});
  @override
  Future<BlogModel> addBlog({required BlogModel blogModel}) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blogModel.toJson())
          .select();
      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required BlogModel blogModel,
    required File image,
  }) async {
    try {
      await supabaseClient.storage
          .from('blog_images')
          .upload(blogModel.id, image);
      return supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(blogModel.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getBlogs() async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)');
      return blogs
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog['profiles']['name']),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // @override
  // Future<BlogModel> getBlogById({required String blogId}) async {
  //   try {
  //     final blog = await supabaseClient
  //         .from('blogs')
  //         .select('*, profiles (name)')
  //         .eq('id', blogId)
  //         .single();
  //     return BlogModel.fromJson(blog).copyWith(
  //       posterName: blog['profiles']['name'],
  //     );
  //   } on PostgrestException catch (e) {
  //     throw ServerException(e.message);
  //   } catch (e) {
  //     throw ServerException(e.toString());
  //   }
  // }
}
