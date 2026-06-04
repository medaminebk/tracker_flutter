import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_flutter/providers/auth_provider.dart';
import 'package:tracker_flutter/screens/login_screen.dart';
import 'package:tracker_flutter/screens/home/home_screen.dart';
import 'package:tracker_flutter/screens/vehicle_list_screen.dart';
import 'package:tracker_flutter/screens/add_vehicle_screen.dart';
import 'package:tracker_flutter/screens/fuel/add_fuel_screen.dart';
import 'package:tracker_flutter/screens/add_maintenance_screen.dart';
import 'package:tracker_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:tracker_flutter/screens/maintenance/maintenance_history_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    initialLocation: '/dashboard',
    navigatorKey: rootNavigatorKey,
    redirect: (context, state) {
      final user = ref.watch(userProvider);
      final isLoggedIn = user != null;
      final isGoingToLogin = state.uri.toString() == '/login';

      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }
      if (isLoggedIn && isGoingToLogin) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vehicles',
                builder: (context, state) => const VehicleListScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const AddVehicleScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/fuel',
                builder: (context, state) => const AddFuelScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const AddFuelScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/maintenance',
                builder: (context, state) => const MaintenanceHistoryScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const AddMaintenanceScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
