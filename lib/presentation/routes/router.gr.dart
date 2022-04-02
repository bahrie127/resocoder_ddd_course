// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    NotesOverviewPageRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const NotesOverviewPage());
    },
    SignInPageRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const SignInPage());
    },
    SplashPageRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const SplashPage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(NotesOverviewPageRoute.name, path: '/notes-overview-page'),
        RouteConfig(SignInPageRoute.name, path: '/sign-in-page'),
        RouteConfig(SplashPageRoute.name, path: '/')
      ];
}

/// generated route for
/// [NotesOverviewPage]
class NotesOverviewPageRoute extends PageRouteInfo<void> {
  const NotesOverviewPageRoute()
      : super(NotesOverviewPageRoute.name, path: '/notes-overview-page');

  static const String name = 'NotesOverviewPageRoute';
}

/// generated route for
/// [SignInPage]
class SignInPageRoute extends PageRouteInfo<void> {
  const SignInPageRoute() : super(SignInPageRoute.name, path: '/sign-in-page');

  static const String name = 'SignInPageRoute';
}

/// generated route for
/// [SplashPage]
class SplashPageRoute extends PageRouteInfo<void> {
  const SplashPageRoute() : super(SplashPageRoute.name, path: '/');

  static const String name = 'SplashPageRoute';
}
