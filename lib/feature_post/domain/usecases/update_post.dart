import 'package:dartz/dartz.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/entities/post_entity.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/repositories/post_repo.dart';

import '../../../core/error/failure.dart';

class UpdatePostUsecase {
  final PostRepo repository;

  UpdatePostUsecase(this.repository);

  Future<Either<Failure, Unit>> call(PostEntity post) async {
    return await repository.updatePost(post);
  }
}
