part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String posterId;
  final File image;
  final String title;
  final String content;
  final List<String> topics;

  BlogUpload({
    required this.posterId,
    required this.image,
    required this.title,
    required this.content,
    required this.topics,
  });
}

final class FetchAllBlogs extends BlogEvent {}

// final class FetchBlogById extends BlogEvent {
//   final String blogId;
//   FetchBlogById({required this.blogId});
// }
