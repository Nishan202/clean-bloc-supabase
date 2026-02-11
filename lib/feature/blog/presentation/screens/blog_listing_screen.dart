import 'package:clean_bloc_supabase/core/theme/app_pallete.dart';
import 'package:clean_bloc_supabase/core/utils/show_snackbar.dart';
import 'package:clean_bloc_supabase/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:clean_bloc_supabase/feature/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogListingScreen extends StatefulWidget {
  const BlogListingScreen({super.key});

  @override
  State<BlogListingScreen> createState() => _BlogListingScreenState();
}

class _BlogListingScreenState extends State<BlogListingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(FetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blogs"),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(CupertinoIcons.add_circled), onPressed: () {}),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                // return ListTile(
                //   title: Text(blog.title),
                //   subtitle: Text(blog.content),
                // );
                return BlogCard(
                  blog: blog,
                  color: index % 3 == 0
                      ? AppPallete.gradient1
                      : index % 3 == 1
                      ? AppPallete.gradient2
                      : AppPallete.gradient3,
                );
              },
            );
          }
          return const Center(child: Text("No blogs found"));
        },
        listener: (BuildContext context, BlogState state) {
          if (state is BlogFailure) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.error)));
            showSnackbar(context, state.error);
          }
        },
      ),
    );
  }
}
