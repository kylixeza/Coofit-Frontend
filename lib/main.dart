import 'package:coofit/presentation/detail_page.dart';
import 'package:coofit/presentation/favorite_page.dart';
import 'package:coofit/presentation/home_page.dart';
import 'package:coofit/presentation/login_page.dart';
import 'package:coofit/presentation/prediction_page.dart';
import 'package:coofit/presentation/register_page.dart';
import 'package:coofit/provider/detail_provider.dart';
import 'package:coofit/provider/home_provider.dart';
import 'package:coofit/provider/login_provider.dart';
import 'package:coofit/style/style.dart';
import 'package:coofit/utils/route_observer.dart';
import 'package:flutter/material.dart';
import 'package:coofit/di/injection.dart' as di;
import 'package:provider/provider.dart';

void main() {
  di.initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.locator<LoginProvider>()),
        ChangeNotifierProvider(create: (_) => di.locator<HomeProvider>()),
        ChangeNotifierProvider(create: (_) => di.locator<DetailProvider>()),
      ],
      child: MaterialApp(
        title: 'Coofit',
        theme: ThemeData(
          primaryColor: primaryColor,
          accentColor: accentColor,
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: coofitTextTheme,
        ),
        home: const HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch(settings.name) {
            case HomePage.routeName:
              return MaterialPageRoute(builder: (_) => const HomePage());
            case LoginPage.routeName:
              return MaterialPageRoute(builder: (_) => const LoginPage());
            case RegisterPage.routeName:
              return MaterialPageRoute(builder: (_) => const RegisterPage());
            case DetailPage.routeName:
              final menuId = settings.arguments as String;
              return MaterialPageRoute(builder: (_) => DetailPage(menuId: menuId), settings: settings);
            case PredictionPage.routeName:
              return MaterialPageRoute(builder: (_) => const PredictionPage());
            case FavoritePage.routeName:
              return MaterialPageRoute(builder: (_) => const FavoritePage());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}