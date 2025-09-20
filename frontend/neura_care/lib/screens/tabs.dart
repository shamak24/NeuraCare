import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:neura_care/providers/theme.dart';
import 'package:neura_care/screens/settings.dart';
import 'package:neura_care/widgets/tabStates/home.dart';
import 'package:neura_care/widgets/tabStates/meals.dart';
import 'package:neura_care/widgets/tabStates/health.dart';

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
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("NeuraCare"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Theme Toggle Button
          IconButton(
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            icon: Icon(currentTheme.icon),
            tooltip:
                'Switch to ${currentTheme == ThemeMode.light
                    ? "Dark"
                    : currentTheme == ThemeMode.dark
                    ? "Light"
                    : "System"} theme',
          ),

          // Settings Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
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
        children: const [HomeTab(), MealsTab(), MedsTab()],
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
