import 'package:markilo/router/app_handlers.dart';
import 'package:markilo/router/auth_handlers.dart';
import 'package:markilo/router/no_page_found_handlers.dart';
import 'package:fluro/fluro.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  // Root route
  static String rootRoute = '/';
  //static String defaultRoute = '/home';

  // Auth Router
  static String loginRoute = '/login';

  // App Router
  static String homeRoute = '/home';
  static String volleyDashboardRoute = '/volley_dashboard';
  static String profileRoute = '/profile';
  static String usersRoute = '/users';
  static String userRoute = '/dashboard/user';
  static String userRouteParamUid = '/:uid';

  static void configureRoutes() {
    // Root route
    router.define(rootRoute,
        handler: AuthHandlers.login, transitionType: TransitionType.none);

    // Auth routes
    router.define(loginRoute,
        handler: AuthHandlers.login, transitionType: TransitionType.none);

    // App routes
    router.define(homeRoute,
        handler: AppHandlers.home, transitionType: TransitionType.fadeIn);
    router.define(profileRoute,
        handler: AppHandlers.profile, transitionType: TransitionType.fadeIn);
    router.define(usersRoute,
        handler: AppHandlers.users, transitionType: TransitionType.fadeIn);
    router.define(userRoute + userRouteParamUid,
        handler: AppHandlers.user, transitionType: TransitionType.fadeIn);

    router.define(volleyDashboardRoute,
        handler: AppHandlers.volleyDashboard,
        transitionType: TransitionType.fadeIn);

    // 404
    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}
