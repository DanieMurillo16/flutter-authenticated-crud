import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/screens/check_auth_status_screen.dart';
import 'package:teslo_shop/features/products/presentation/screens/product_screen.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouterProvider = Provider(
  (ref) {
    final goRouterNotifier = ref.read(goRouterNotifierProvier);
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: goRouterNotifier,
      routes: [
        //Check auth
        GoRoute(
          path: '/splash',
          builder: (context, state) => const CheckAuthStatusScreen(),
        ),

        ///* Auth Routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        ///* Product Routes
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductsScreen(),
        ),

        ///* Product information
        GoRoute(
          path: '/product/:id',
          builder: (context, state) => ProductScreen(
            productId: state.params['id'] ?? 'noid',
          ),
        ),
      ],
      redirect: (context, state) {
        final isGoingTo = state.subloc;
        final authStatus = goRouterNotifier.authStatus;

        // Si aún estamos comprobando el estado, quédate en la pantalla de carga.
        if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
          return null;
        }

        // Si el usuario NO está autenticado...
        if (authStatus == AuthStatus.notAuthenticated) {
          // ... y está intentando ir a la pantalla de login o registro, déjalo pasar.
          if (isGoingTo == '/login' || isGoingTo == '/register') {
            return null; // No hagas nada, la ruta es correcta.
          }
          // Para cualquier otra ruta, mándalo al login.
          return '/login';
        }

        // Si el usuario SÍ está autenticado...
        if (authStatus == AuthStatus.authenticated) {
          // ... y está intentando ir al login, registro o splash, mándalo a la home.
          if (isGoingTo == '/login' ||
              isGoingTo == '/register' ||
              isGoingTo == '/splash') {
            return '/';
          }
        }
        // Si ninguna de las condiciones anteriores se cumple, no redirijas.
        return null;
      },
    );
  },
);
