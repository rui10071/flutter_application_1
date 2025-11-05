import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'home_screen.dart';
import 'selection_screen.dart';
import 'mydata_screen.dart';
import 'profile_screen.dart';

final mainNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  final List<Widget> _pages = [
    HomeScreen(),
    SelectionScreen(),
    MyDataScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainNavIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? kCardDark : kCardLight,
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1)),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, ref, icon: Icons.home_filled, label: "ホーム", index: 0),
              _buildNavItem(context, ref, icon: Icons.fitness_center, label: "トレーニング", index: 1),
              _buildNavItem(context, ref, icon: Icons.bar_chart, label: "記録", index: 2),
              _buildNavItem(context, ref, icon: Icons.person, label: "プロフィール", index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, WidgetRef ref, {required IconData icon, required String label, required int index}) {
    final bool isSelected = ref.watch(mainNavIndexProvider) == index;
    final Color color = isSelected ? kPrimaryColor : (Theme.of(context).brightness == Brightness.dark ? kTextDarkSecondary : kTextLightSecondary);

    return GestureDetector(
      onTap: () {
        ref.read(mainNavIndexProvider.notifier).state = index;
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

