import 'package:flutter/material.dart';
import '../theme.dart';
import '../home_screen.dart';
import '../selection_screen.dart';
import '../mydata_screen.dart';
import '../profile_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? kCardDark : kCardLight,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, icon: Icons.home_filled, label: "ホーム", index: 0),
            _buildNavItem(context, icon: Icons.fitness_center, label: "トレーニング", index: 1),
            _buildNavItem(context, icon: Icons.bar_chart, label: "記録", index: 2),
            _buildNavItem(context, icon: Icons.person, label: "プロフィール", index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required IconData icon, required String label, required int index}) {
    final bool isSelected = currentIndex == index;
    final Color color = isSelected ? kPrimaryColor : (Theme.of(context).brightness == Brightness.dark ? kTextDarkSecondary : kTextLightSecondary);

    return GestureDetector(
      onTap: () {
        if (isSelected) return;
        
        Widget page;
        switch (index) {
          case 0:
            page = HomeScreen();
            break;
          case 1:
            page = SelectionScreen();
            break;
          case 2:
            page = MyDataScreen();
            break;
          case 3:
            page = ProfileScreen();
            break;
          default:
            page = HomeScreen();
        }
        
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => page,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
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

