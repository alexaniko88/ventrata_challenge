import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ventrata_challenge/di/di.dart';
import 'package:ventrata_challenge/domain/login/cubits/login_cubit.dart';
import 'package:ventrata_challenge/domain/login/entities/login_model.dart';
import 'package:ventrata_challenge/presentation/home/home_page.dart';
import 'package:ventrata_challenge/presentation/login/login_page.dart';

enum RoutePath {
  login('/'),
  home('/home');

  final String value;

  const RoutePath(this.value);
}

class Routes {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: RoutePath.login.value,
        name: RoutePath.login.value,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<LoginCubit>(),
              ),
            ],
            child: const LoginPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutePath.home.value,
        name: RoutePath.home.value,
        pageBuilder: (context, state) {
          final token = state.extra as String;
          return MaterialPage(
            key: state.pageKey,
            child: HomePage(token: token),
          );
        },
      ),
    ],
  );
}