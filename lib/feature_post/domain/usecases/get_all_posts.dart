import 'package:dartz/dartz.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/repositories/post_repo.dart';

import '../../../core/error/failure.dart';
import '../entities/post_entity.dart';

class GetAllPostsUsecase {
  final PostRepo repository;

  GetAllPostsUsecase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call() async {
    return await repository.getAllPosts();
  }
}
