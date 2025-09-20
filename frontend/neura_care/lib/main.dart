import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:neura_care/models/user.dart';
import 'package:neura_care/models/vitals.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/vitals.dart';
import 'package:neura_care/screens/auth/login.dart';
import 'package:neura_care/screens/tabs.dart';
import 'package:neura_care/screens/onboarding.dart';
import 'package:neura_care/services/api.dart';
import 'package:neura_care/services/hive_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await setupHive();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _initialize() async {
      if (!await InternetConnection().hasInternetAccess) {
        throw Exception('No internet connection');
      }
      ref.read(userProviderNotifier.notifier).loadUserData();
      User user = ref.read(userProviderNotifier);
      try {
        if (user != User.empty()) {
          await verifyToken(user.token!);
        }
      } catch (e) {
        print('Error verifying token: $e');
        ref.read(userProviderNotifier.notifier).clearUser();
        ref.read(vitalsProviderNotifier.notifier).clearVitals();
      }
      try {
        ref.read(vitalsProviderNotifier.notifier).loadVitalsData();
      } catch (e) {
        print('Error loading vitals: $e');
      }
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        future: _initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError &&
              snapshot.error.toString().contains('No internet connection')) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error: Please check your internet connection.'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _initialize();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          }
          return Consumer(
            builder: (context, ref, _) {
              final userProvider = ref.watch(userProviderNotifier);
              if (userProvider == User.empty()) {
                return const LoginScreen();
              } else {
                final vitalsProvider = ref.watch(vitalsProviderNotifier);
                if (vitalsProvider == Vitals.empty()) {
                  return const OnboardingScreen();
                }
                return TabsScreen();
              }
            },
          );
        },
      ),
    );
  }
}
