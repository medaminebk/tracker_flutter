import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_flutter/providers/auth_provider.dart';
import 'package:tracker_flutter/screens/login_screen.dart';
import 'package:tracker_flutter/screens/home_screen.dart';
import 'package:tracker_flutter/screens/vehicle_list_screen.dart';
import 'package:tracker_flutter/screens/add_vehicle_screen.dart';
import 'package:tracker_flutter/screens/add_fuel_screen.dart';
import 'package:tracker_flutter/screens/add_maintenance_screen.dart';
import 'package:tracker_flutter/screens/dashboard/dashboard_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final user = ref.watch(userProvider);
      final isLoggedIn = user != null;
      final isGoingToLogin = state.uri.toString() == '/login';

      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }
      if (isLoggedIn && isGoingToLogin) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: 'vehicles',
            builder: (context, state) => const VehicleListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddVehicleScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'fuel/add',
            builder: (context, state) => const AddFuelScreen(),
          ),
          GoRoute(
            path: 'maintenance/add',
            builder: (context, state) => const AddMaintenanceScreen(),
          ),
        ],
      ),
    ],
  );
});
