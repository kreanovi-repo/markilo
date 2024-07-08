import 'package:markilo/providers/user_form_provider.dart';
import 'package:markilo/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:markilo/api/surikato_api.dart';
import 'package:markilo/providers/auth_provider.dart';
import 'package:markilo/providers/home_provider.dart';
import 'package:markilo/providers/sidemenu_provider.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/data_service.dart';
import 'package:markilo/services/local_storage.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/services/notification_service.dart';
import 'package:markilo/ui/layouts/auth/auth_layout.dart';
import 'package:markilo/ui/layouts/splash/splash_layout.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'ui/layouts/app/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataService.getConfiguration();
  await LocalStorage.configPrefs();
  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['es', 'en'],
    assetsDirectory: 'assets/lang/',
  );
  SurikatoApi.configureDio();
  Flurorouter.configureRoutes();
  runApp(Phoenix(child: const AppState()));
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => AuthProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => SideMenuProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => UserFormProvider())
      ],
      child: const LocalizedApp(child: MarkiloApp()),
    );
  }
}

class MarkiloApp extends StatelessWidget {
  const MarkiloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Flurorouter.homeRoute,
      onGenerateRoute: Flurorouter.router.generator,
      navigatorKey: NavigationService.navigatorKey,
      scaffoldMessengerKey: NotificationService.messengerKey,
      localizationsDelegates: translator.delegates,
      locale: translator.activeLocale,
      supportedLocales: translator.locals(),
      title: "MARKILO",
      builder: (_, child) {
        //print(LocalStorage.prefs.getString('token'));
        translator.setNewLanguage(context, newLanguage: 'es', remember: true);
        final authProvider = Provider.of<AuthProvider>(context);
        if (AuthStatus.checking == authProvider.authStatus) {
          return const Center(
            child: SplashLayout(),
          );
        }

        if (AuthStatus.authenticated == authProvider.authStatus) {
          return MainLayout(
            authProvider: authProvider,
            child: child!,
          );
        } else {
          return AuthLayout(child: child!);
        }
      },
      theme: ThemeData.light().copyWith(
          scrollbarTheme: const ScrollbarThemeData().copyWith(
              thumbColor: WidgetStateProperty.all(Colors.grey[500]))),
    );
  }
}
