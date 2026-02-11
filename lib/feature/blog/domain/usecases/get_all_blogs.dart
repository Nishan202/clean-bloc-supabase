import 'package:clean_bloc_supabase/core/error/failures.dart';
import 'package:clean_bloc_supabase/core/usecase/usecase.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/entities/blog.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements Usecase<List<Blog>, NoParams> {
  BlogRepository blogRepository;
  GetAllBlogs({required this.blogRepository});
  @override
  Future<Either<Failures, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
