import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_clean_arch_bloc/core/urils/snackbar_message.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/entities/post_entity.dart';
import 'package:post_clean_arch_bloc/feature_post/presentation/blocs/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:post_clean_arch_bloc/feature_post/presentation/pages/post_add_update/widgets/form_widget.dart';
import 'package:post_clean_arch_bloc/feature_post/presentation/pages/post_page/post_page.dart';

import '../../widgets/loading_widget.dart';

class PostAddUpdatePage extends StatelessWidget {
  const PostAddUpdatePage({Key? key, this.posts, required this.isUpdatePost})
      : super(key: key);
  final PostEntity? posts;
  final bool isUpdatePost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdatePost ? "Update Post" : "Add Post"),
      ),
      body: Center(
        child: BlocConsumer<AddDeleteUpdatePostBloc, AddDeleteUpdatePostState>(
          listener: (context, state) {
            if (state is MessageAddDeleteUpdatePostState) {
              SnackBarMessage().showSuccessSnackBar(
                  message: state.message, context: context);

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const PostPage(),
                  ),
                  (route) => false);
            } else if (state is ErrorAddDeleteUpdatePostState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ));
            }
          },
          builder: (context, state) {
            if (state is LoadingAddDeleteUpdatePostState) {
              return const LoadingWidget();
            }
            return FormWidget(
                posts: isUpdatePost ? posts : null, isUpdatePost: isUpdatePost);
          },
        ),
      ),
    );
  }
}
