import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:neura_care/models/user.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/screens/auth/login.dart';
import 'package:neura_care/screens/home.dart';
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

      print('Loading user data from Hive');
      ref.read(userProviderNotifier.notifier).loadUserData();
      print('User data loaded');
      User user = ref.read(userProviderNotifier);
      try{
        if (user != User.empty()) {
          await verifyToken(user.token!);
        }
      } catch (e) {
        print('Error verifying token: $e');
        ref.read(userProviderNotifier.notifier).clearUser();
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
          } else if (snapshot.hasError && snapshot.error.toString().contains('No internet connection')) {
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
          }
          return Consumer(
            builder: (context, ref, _) {
              final userProvider = ref.watch(userProviderNotifier);
              if (userProvider == User.empty()) {
                return const LoginScreen();
              } else {
                return const HomeScreen();
              }
            },
          );
        },
      ),
    );
  }
}
