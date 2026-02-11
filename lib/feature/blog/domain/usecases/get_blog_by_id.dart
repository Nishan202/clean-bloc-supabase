// import 'package:clean_bloc_supabase/core/error/failures.dart';
// import 'package:clean_bloc_supabase/core/usecase/usecase.dart';
// import 'package:clean_bloc_supabase/feature/blog/domain/entities/blog.dart';
// import 'package:clean_bloc_supabase/feature/blog/domain/repository/blog_repository.dart';
// import 'package:fpdart/fpdart.dart';

// class GetBlogById implements Usecase<Blog, GetBlogByIdParams> {
//   BlogRepository blogRepository;
//   GetBlogById({required this.blogRepository});

//   @override
//   Future<Either<Failures, Blog>> call(GetBlogByIdParams params) async {
//     return await blogRepository.getBlogById(blogId: params.blogId);
//   }
// }

// class GetBlogByIdParams {
//   final String blogId;
//   GetBlogByIdParams({required this.blogId});
// }
