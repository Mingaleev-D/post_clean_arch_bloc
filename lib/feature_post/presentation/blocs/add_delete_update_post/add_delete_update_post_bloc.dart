import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/string/failures.dart';
import '../../../../core/string/message.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/usecases/add_post.dart';
import '../../../domain/usecases/delete_post.dart';
import '../../../domain/usecases/update_post.dart';

part 'add_delete_update_post_event.dart';

part 'add_delete_update_post_state.dart';

class AddDeleteUpdatePostBloc
    extends Bloc<AddDeleteUpdatePostEvent, AddDeleteUpdatePostState> {
  final AddPostUsecase addPostUsecase;
  final UpdatePostUsecase updatePostUsecase;
  final DeletePostUsecase deletePostUsecase;

  AddDeleteUpdatePostBloc(
      {required this.addPostUsecase,
      required this.updatePostUsecase,
      required this.deletePostUsecase})
      : super(AddDeleteUpdatePostInitial()) {
    on<AddDeleteUpdatePostEvent>((event, emit) async {
      if (event is AddPostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final result = await addPostUsecase(event.post);
        result.fold(
          (failure) => emit(ErrorAddDeleteUpdatePostState(
              message: _mapFailureToMessage(failure))),
          (_) => emit(const MessageAddDeleteUpdatePostState(
              message: ADD_SUCCESS_MESSAGE)),
        );
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final result = await updatePostUsecase(event.post);
        result.fold(
          (failure) => emit(ErrorAddDeleteUpdatePostState(
              message: _mapFailureToMessage(failure))),
          (_) => emit(const MessageAddDeleteUpdatePostState(
              message: UPDATE_SUCCESS_MESSAGE)),
        );
      } else if (event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final result = await deletePostUsecase(event.postId);
        result.fold(
          (failure) => emit(ErrorAddDeleteUpdatePostState(
              message: _mapFailureToMessage(failure))),
          (_) => emit(const MessageAddDeleteUpdatePostState(
              message: DELETE_SUCCESS_MESSAGE)),
        );
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
