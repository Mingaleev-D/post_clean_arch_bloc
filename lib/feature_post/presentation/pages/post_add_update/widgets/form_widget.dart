import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/entities/post_entity.dart';

import '../../../blocs/add_delete_update_post/add_delete_update_post_bloc.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key, required this.isUpdatePost, this.posts})
      : super(key: key);
  final bool isUpdatePost;
  final PostEntity? posts;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdatePost) {
      _titleController.text = widget.posts!.title;
      _bodyController.text = widget.posts!.body;
    }
    super.initState();
  }

  void validateFormThenUpdateOrAddPost() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final posts = PostEntity(
          id: widget.isUpdatePost ? widget.posts!.id : null,
          title: _titleController.text,
          body: _bodyController.text);
      if (widget.isUpdatePost) {
        BlocProvider.of<AddDeleteUpdatePostBloc>(context).add(
          UpdatePostEvent(
            post: posts,
          ),
        );
      } else {
        BlocProvider.of<AddDeleteUpdatePostBloc>(context).add(
          AddPostEvent(
            post: posts,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// title entered
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextFormField(
              controller: _titleController,
              validator: (value) =>
                  value!.isEmpty ? "Title cannot be empty" : null,
              decoration: const InputDecoration(
                hintText: 'Enter title',
              ),
            ),
          ),

          /// body entered
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextFormField(
              controller: _bodyController,
              validator: (value) =>
                  value!.isEmpty ? "Body cannot be empty" : null,
              decoration: const InputDecoration(
                hintText: 'Enter body',
              ),
              maxLines: 6,
              minLines: 6,
            ),
          ),
          ElevatedButton.icon(
            onPressed: validateFormThenUpdateOrAddPost,
            icon: widget.isUpdatePost
                ? const Icon(Icons.update)
                : const Icon(Icons.add),
            label:
                widget.isUpdatePost ? const Text("Update") : const Text("Add"),
          )
        ],
      ),
    );
  }
}
