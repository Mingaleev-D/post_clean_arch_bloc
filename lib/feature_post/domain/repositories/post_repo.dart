import 'package:dartz/dartz.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/entities/post_entity.dart';

import '../../../core/error/failure.dart';

abstract class PostRepo {
  Future<Either<Failure, List<PostEntity>>> getAllPosts();
  Future<Either<Failure, Unit>> deletePost(int id);
  Future<Either<Failure, Unit>> updatePost(PostEntity post);
  Future<Either<Failure, Unit>> addPost(PostEntity post);
}
