import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'landing_screen.dart';
import '../../../../features/home_customer/presentation/screens/customer_home_screen.dart';
import '../../../../features/dashboard_builder/presentation/screens/builder_dashboard_screen.dart';

// 1. Provider to check if user is logged in
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// 2. Provider to fetch user role from Firestore
final userRoleProvider = FutureProvider.family<String?, String>((ref, uid) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return doc.data()?['role'] as String?;
});

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Not logged in -> Show Landing Page
          return const LandingScreen();
        } else {
          // Logged in -> Check Role
          final roleAsync = ref.watch(userRoleProvider(user.uid));

          return roleAsync.when(
            data: (role) {
              if (role == 'builder') {
                return const BuilderDashboardScreen();
              } else {
                // Default to Customer if role is missing or 'customer'
                return const CustomerHomeScreen();
              }
            },
            loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => Scaffold(
              body: Center(child: Text("Error: $err")),
            ),
          );
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text("Auth Error: $err")),
      ),
    );
  }
}