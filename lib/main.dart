import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature_post/presentation/blocs/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'feature_post/presentation/blocs/posts/posts_bloc.dart';
import 'feature_post/presentation/pages/post_page/post_page.dart';
import 'injection_container.dart' as di;
import 'core/theme/t_app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<PostsBloc>()..add(GetAllPostsEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<AddDeleteUpdatePostBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: tAppTheme,
        home: const PostPage(),
      ),
    );
  }
}
