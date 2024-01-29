import 'package:dartz/dartz.dart';
import 'package:post_clean_arch_bloc/core/error/exceptions.dart';
import 'package:post_clean_arch_bloc/core/error/failure.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/entities/post_entity.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/repositories/post_repo.dart';

import '../../../core/network/network_info.dart';
import '../datasources/local/post_local_datasource.dart';
import '../datasources/remote/post_remote_datasource.dart';
import '../models/posts_model.dart';

class PostRepoImpl implements PostRepo {
  final PostRemoteDatasource remote;
  final PostLocalDataSource local;
  final NetworkInfo networkInfo;

  const PostRepoImpl(
      {required this.remote, required this.local, required this.networkInfo});

  @override
  Future<Either<Failure, Unit>> addPost(PostEntity post) async {
    final PostsModel postModel = PostsModel(
      // id: post.id,
      title: post.title,
      body: post.body,
    );
    return await _getMessage(() => remote.addPost(postModel));
    /*
        if (await networkInfo.isConnected) {
      try {
        await remote.addPost(postModel);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
     */
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int id) async {
    return await _getMessage(() => remote.deletePost(id));

    /*
     if (await networkInfo.isConnected) {
      try {
        await remote.deletePost(id);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
    */
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remote.getAllPosts();
        local.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await local.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePost(PostEntity post) async {
    final PostsModel postModel = PostsModel(
      id: post.id,
      title: post.title,
      body: post.body,
    );
    return await _getMessage(() => remote.updatePost(postModel));

    /*
        if (await networkInfo.isConnected) {
      try {
        await remote.updatePost(postModel);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
     */
  }

  ///* расширение */
  Future<Either<Failure, Unit>> _getMessage(Future<Unit> Function() fn) async {
    if (await networkInfo.isConnected) {
      try {
        await fn();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
