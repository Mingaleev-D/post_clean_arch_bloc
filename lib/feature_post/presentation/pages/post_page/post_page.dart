import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_clean_arch_bloc/feature_post/presentation/blocs/posts/posts_bloc.dart';
import 'package:post_clean_arch_bloc/feature_post/presentation/pages/post_add_update/post_add_update_page.dart';

import '../../widgets/loading_widget.dart';
import '../../widgets/message_display_widget.dart';
import '../../widgets/post_list_widget.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(("Posts")),
        ),
        body: const BuildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostAddUpdatePage(
                    isUpdatePost: false,
                  ),
                ));
          },
          child: const Icon(CupertinoIcons.add),
        ));
  }
}

class BuildBody extends StatelessWidget {
  const BuildBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is LoadingPostsState) {
            return const LoadingWidget();
          } else if (state is LoadedSuccessPostsState) {
            return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<PostsBloc>(context).add(RefreshPostEvent());
                },
                child: PostListWidget(posts: state.posts));
          } else if (state is ErrorPostsState) {
            return MessageDisplayWidget(message: state.message);
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
