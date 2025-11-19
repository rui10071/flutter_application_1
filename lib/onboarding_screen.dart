import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'theme.dart';
import 'login_or_signup_screen.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}


class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  final List<Map<String, String>> _pages = [
    {
      "title": "AIフォーム解析",
      "desc": "最新のAIがあなたのトレーニング姿勢をリアルタイムで解析。正しいフォームで効率的なボディメイクを。",
      "image": "https://images.unsplash.com/photo-1517963879433-6ad2b056d712?q=80&w=2940&auto=format&fit=crop",
    },
    {
      "title": "成長を可視化",
      "desc": "トレーニング履歴とスコアを自動で記録。グラフで成長を実感し、モチベーションを維持しましょう。",
      "image": "https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=2940&auto=format&fit=crop",
    },
    {
      "title": "1週間無料体験",
      "desc": "全ての機能を1週間無料でお試しいただけます。気に入らなければいつでもキャンセル可能です。",
      "image": "https://images.unsplash.com/photo-1534258936925-c48947387603?q=80&w=2000&auto=format&fit=crop",
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(
                _pages[index]["title"]!,
                _pages[index]["desc"]!,
                _pages[index]["image"]!,
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? kPrimaryColor : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                if (_currentPage == _pages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginOrSignupScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text("始める", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Lexend')),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                           Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginOrSignupScreen()),
                          );
                        },
                        child: Text("スキップ", style: TextStyle(color: Colors.white54)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          foregroundColor: Colors.white,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16),
                        ),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPage(String title, String desc, String imageUrl) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.black),
            errorWidget: (context, url, error) => Container(color: Color(0xFF122017)),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ],
                stops: [0.4, 0.8, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(flex: 3),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Noto Sans JP',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


