import 'package:post_clean_arch_bloc/feature_post/domain/entities/post_entity.dart';

class PostsModel extends PostEntity {
  const PostsModel({
    int? id,
    required String title,
    required String body,
  }) : super(id: id, title: title, body: body);

  factory PostsModel.fromJson(Map<String, dynamic> json) {
    return PostsModel(id: json['id'], title: json['title'], body: json['body']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'body': body};
  }
}
