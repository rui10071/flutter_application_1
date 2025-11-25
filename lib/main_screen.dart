import 'dart:ui';
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


    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 8,
                top: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, ref, icon: Icons.home_filled, label: "ホーム", index: 0), 
                  _buildNavItem(context, ref, icon: Icons.fitness_center_rounded, label: "ワークアウト", index: 1),
                  _buildNavItem(context, ref, icon: Icons.bar_chart_rounded, label: "記録", index: 2),
                  _buildNavItem(context, ref, icon: Icons.person_rounded, label: "プロフィール", index: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildNavItem(BuildContext context, WidgetRef ref, {required IconData icon, required String label, required int index}) {
    final bool isSelected = ref.watch(mainNavIndexProvider) == index;
    final Color color = isSelected ? kPrimaryColor : Colors.white38;


    return GestureDetector(
      onTap: () {
        ref.read(mainNavIndexProvider.notifier).state = index;
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}


