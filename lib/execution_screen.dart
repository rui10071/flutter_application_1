import 'package:flutter/material.dart';
import 'theme.dart';
import 'result_screen.dart';

class ExecutionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuCdTPV-webaS0Xiajsq7bH2CIBaIO3O5XaCeXBh8vkBDdz2NqExqlvovMC-ZTQdJ5ccPGWhEs1PqFPz49xETuxATsEfGgNcJAIat-noKRhuuhwq_Xs0wHzs6UHzWVXx4CNCGTbRZgJPhtf3CoFM1QbQQVtK3h8eKXpGp_zu4JLOju8cI4fiaEHZb2zX8Hl8gMnW1nu9TFVBOz6_qxftKuInoQifs7M_hM9da_8BDi0uWS4_3Yc81a7_BJx4WKaL2cnTnTNEXaE9nik"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          
          _buildSkeleton(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildHeader(),
                  Spacer(),
                  _buildFeedback(),
                  SizedBox(height: 16),
                  _buildControls(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "10",
              style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold, height: 1.0),
            ),
            Text(
              "reps",
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 24),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildFeedback() {
    return Column(
      children: [
        _buildFeedbackCard(
          icon: Icons.error,
          text: "右膝をもう少し曲げましょう",
          color: kHighlight,
          isError: true,
        ),
        SizedBox(height: 8),
        _buildFeedbackCard(
          icon: Icons.check_circle,
          text: "背筋はまっすぐです",
          color: kPrimaryColor,
        ),
      ],
    );
  }

  Widget _buildFeedbackCard({required IconData icon, required String text, required Color color, bool isError = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: isError ? Border.all(color: color, width: 1) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(width: 16),
          Expanded(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.volume_up, color: Colors.white.withOpacity(0.8), size: 30),
            onPressed: () {},
          ),
          SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: kPrimaryColor,
              padding: EdgeInsets.all(16),
            ),
            child: Icon(Icons.pause, color: kBackgroundDark, size: 36),
            onPressed: () {},
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.stop, color: Colors.white.withOpacity(0.8), size: 30),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ResultScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return IgnorePointer(
      child: Container(
        child: CustomPaint(
          size: Size.infinite,
          painter: SkeletonPainter(),
        ),
      ),
    );
  }
}

class SkeletonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4
      ..color = kPrimaryColor;
      
    final errorPaint = Paint()
      ..strokeWidth = 4
      ..color = kHighlight;

    final points = {
      'p1': Offset(size.width * 0.50, size.height * 0.20),
      'p2': Offset(size.width * 0.45, size.height * 0.30),
      'p3': Offset(size.width * 0.55, size.height * 0.31),
      'p4': Offset(size.width * 0.40, size.height * 0.45),
      'p5': Offset(size.width * 0.60, size.height * 0.46),
      'p6': Offset(size.width * 0.50, size.height * 0.50),
      'p7': Offset(size.width * 0.45, size.height * 0.65),
      'p8': Offset(size.width * 0.55, size.height * 0.66),
      'p9': Offset(size.width * 0.42, size.height * 0.85),
      'p10': Offset(size.width * 0.58, size.height * 0.87),
    };

    canvas.drawCircle(points['p1']!, 8, paint);
    canvas.drawCircle(points['p2']!, 8, paint);
    canvas.drawCircle(points['p3']!, 8, paint);
    canvas.drawCircle(points['p4']!, 8, paint);
    canvas.drawCircle(points['p5']!, 8, paint);
    canvas.drawCircle(points['p6']!, 8, paint);
    canvas.drawCircle(points['p7']!, 8, paint);
    canvas.drawCircle(points['p8']!, 8, paint);
    canvas.drawCircle(points['p9']!, 8, paint);
    canvas.drawCircle(points['p10']!, 8, errorPaint);
    
    canvas.drawLine(points['p1']!, points['p6']!, paint);
    canvas.drawLine(points['p2']!, points['p3']!, paint);
    canvas.drawLine(points['p2']!, points['p4']!, paint);
    canvas.drawLine(points['p3']!, points['p5']!, paint);
    canvas.drawLine(points['p6']!, points['p7']!, paint);
    canvas.drawLine(points['p6']!, points['p8']!, paint);
    canvas.drawLine(points['p7']!, points['p9']!, paint);
    canvas.drawLine(points['p8']!, points['p10']!, errorPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

