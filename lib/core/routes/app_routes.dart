import 'package:ala_feen/features/get_started/screens/get_started_view.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const GetStartedView(),
    ),
  ],
);
