import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_clean_arch_bloc/core/string/failures.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/entities/post_entity.dart';

import '../../../../core/error/failure.dart';
import '../../../domain/usecases/get_all_posts.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostsUsecase getAllPostsUsecase;

  PostsBloc({required this.getAllPostsUsecase}) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        emit(LoadingPostsState());
        final posts = await getAllPostsUsecase.call();
        posts.fold(
          (failure) {
            emit(ErrorPostsState(message: _mapFailureToMessage(failure)));
          },
          (posts) {
            emit(LoadedSuccessPostsState(posts: posts));
          },
        );
      } else if (event is RefreshPostEvent) {
        emit(LoadingPostsState());
        final posts = await getAllPostsUsecase.call();
        posts.fold(
          (failure) {
            emit(ErrorPostsState(message: _mapFailureToMessage(failure)));
          },
          (posts) {
            emit(LoadedSuccessPostsState(posts: posts));
          },
        );
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
