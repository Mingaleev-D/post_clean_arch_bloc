import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:post_clean_arch_bloc/feature_post/data/datasources/local/post_local_datasource.dart';
import 'package:post_clean_arch_bloc/feature_post/data/datasources/remote/post_remote_datasource.dart';
import 'package:post_clean_arch_bloc/feature_post/data/repositories/post_repo_impl.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/repositories/post_repo.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/usecases/add_post.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/usecases/delete_post.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/usecases/get_all_posts.dart';
import 'package:post_clean_arch_bloc/feature_post/domain/usecases/update_post.dart';
import 'package:post_clean_arch_bloc/feature_post/presentation/blocs/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:post_clean_arch_bloc/feature_post/presentation/blocs/posts/posts_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  ///* features =posts

  //* block
  sl.registerFactory(() => PostsBloc(getAllPostsUsecase: sl()));
  sl.registerFactory(() => AddDeleteUpdatePostBloc(
      addPostUsecase: sl(), updatePostUsecase: sl(), deletePostUsecase: sl()));

  //* usecase
  sl.registerLazySingleton(() => GetAllPostsUsecase(sl()));
  sl.registerLazySingleton(() => AddPostUsecase(sl()));
  sl.registerLazySingleton(() => DeletePostUsecase(sl()));
  sl.registerLazySingleton(() => UpdatePostUsecase(sl()));

  //* repo
  sl.registerLazySingleton<PostRepo>(
      () => PostRepoImpl(remote: sl(), local: sl(), networkInfo: sl()));

  //* datasource
  sl.registerLazySingleton<PostRemoteDatasource>(
      () => PostRemoteDatasourceImplWithHttp(client: sl()));
  sl.registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(prefs: sl()));

  /// * Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /// * external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
