import 'package:markilo/providers/auth_provider.dart';
import 'package:markilo/ui/views/home_view.dart';
import 'package:markilo/ui/views/login_view.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

class AuthHandlers {
  static Handler login = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    if (AuthStatus.notAuthenticated == authProvider.authStatus) {
      return const LoginView();
    } else {
      return const HomeView();
    }
  });
}
