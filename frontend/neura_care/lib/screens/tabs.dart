import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:neura_care/providers/daily_meals.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/vitals.dart';
import 'package:neura_care/screens/settings.dart';
import 'package:neura_care/widgets/tabStates/home.dart';
import 'package:neura_care/widgets/tabStates/meals.dart';
import 'package:neura_care/widgets/tabStates/meds.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NeuraCare"),
        backgroundColor:  Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          }, icon: const Icon(Icons.settings)),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              ref.read(vitalsProviderNotifier.notifier).clearVitals();
              ref.read(userProviderNotifier.notifier).clearUser();
              ref.read(dailyMealsProviderNotifier.notifier).clearDailyMeals();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _pageIndex = index;
          });
        },
        children: const [
          HomeTab(),
          MealsTab(),
          MedsTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _pageIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Diet'),
          NavigationDestination(icon: Icon(Icons.medication), label: 'Health'),
        ],
      ),
    );
  }
}
