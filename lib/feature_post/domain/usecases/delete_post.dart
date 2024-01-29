import 'package:dartz/dartz.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/repositories/post_repo.dart';

import '../../../core/error/failure.dart';

class DeletePostUsecase {
  final PostRepo repository;

  DeletePostUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int postId) async {
    return await repository.deletePost(postId);
  }
}
