import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'result_screen.dart';
import 'dart:async';
import 'dart:math';
import 'pose_frame.dart';
import 'main_screen.dart';
import 'training_model.dart';


class ExecutionScreen extends ConsumerStatefulWidget {
  final TrainingMenu menu;


  ExecutionScreen({required this.menu});


  @override
  _ExecutionScreenState createState() => _ExecutionScreenState();
}


class _ExecutionScreenState extends ConsumerState<ExecutionScreen> {
  late StreamController<PoseFrame> _streamController;
  late Stream<PoseFrame> _poseStream;
  late Timer _mockTimer;
  
  int _mockSecondsElapsed = 0;
  int _reps = 10;


  final List<Map<String, dynamic>> _feedbackMessages = [
    {
      "text": "良いフォームです！その調子。",
      "icon": Icons.check_circle,
      "color": kPrimaryColor,
      "isError": false,
      "errorPoint": null,
    },
    {
      "text": "腰をもう少し下げましょう。",
      "icon": Icons.warning_amber_rounded,
      "color": kHighlight,
      "isError": true,
      "errorPoint": "p10",
    },
    {
      "text": "背筋が伸びています。完璧です。",
      "icon": Icons.check_circle,
      "color": kPrimaryColor,
      "isError": false,
      "errorPoint": null,
    },
    {
      "text": "膝の位置に注意してください。",
      "icon": Icons.warning_amber_rounded,
      "color": kHighlight,
      "isError": true,
      "errorPoint": "p6",
    },
  ];


  @override
  void initState() {
    super.initState();
    _streamController = StreamController<PoseFrame>();
    _poseStream = _streamController.stream;


    _mockTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _mockSecondsElapsed++;
      
      int feedbackIndex = (_mockSecondsElapsed ~/ 30) % _feedbackMessages.length;
      var feedback = _feedbackMessages[feedbackIndex];
      
      if (_mockSecondsElapsed > 0 && _mockSecondsElapsed % 50 == 0) {
        setState(() {
           _reps++;
        });
      }
      
      double breathing = sin(_mockSecondsElapsed * 0.1) * 2.0;
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      
      final Map<String, Offset> points = {
        'p1': Offset(size.width * 0.50, size.height * 0.20 + breathing),
        'p2': Offset(size.width * 0.45, size.height * 0.30),
        'p3': Offset(size.width * 0.55, size.height * 0.31),
        'p4': Offset(size.width * 0.40, size.height * 0.45),
        'p5': Offset(size.width * 0.60, size.height * 0.46),
        'p6': Offset(size.width * 0.50, size.height * 0.50 + breathing),
        'p7': Offset(size.width * 0.45, size.height * 0.65),
        'p8': Offset(size.width * 0.55, size.height * 0.66),
        'p9': Offset(size.width * 0.42, size.height * 0.85),
        'p10': Offset(size.width * 0.58, size.height * 0.87),
      };


      final Map<String, Color> pointColors = {};
      final paintOK = kPrimaryColor;
      final paintError = kHighlight;
      final paintAssist = Colors.blue.shade400;


      for (var key in points.keys) {
        if (key == feedback["errorPoint"]) {
          pointColors[key] = paintError;
        } else if (widget.menu.assistPivotKeys.contains(key)) {
          pointColors[key] = paintAssist;
        } else {
          pointColors[key] = paintOK;
        }
      }


      if (!_streamController.isClosed) {
        _streamController.add(PoseFrame(
          points: points,
          pointColors: pointColors,
          feedbackText: feedback["text"],
          feedbackIcon: feedback["icon"],
          feedbackColor: feedback["color"],
          isError: feedback["isError"],
          reps: _reps,
        ));
      }
    });
  }


  @override
  void dispose() {
    _mockTimer.cancel();
    _streamController.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<PoseFrame>(
        stream: _poseStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Stack(
              children: [
                Container(color: Colors.black),
                Center(child: CircularProgressIndicator(color: kPrimaryColor)),
              ],
            );
          }
          
          final poseFrame = snapshot.data!;


          return Stack(
            children: [
              // カメラ映像のプレースホルダー（黒背景）
              Positioned.fill(
                child: Container(
                  color: Colors.black, 
                ),
              ),
              
              // 骨格描画レイヤー
              _buildSkeleton(poseFrame),


              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildHeader(context, poseFrame.reps),
                      Spacer(),
                      _buildFeedback(poseFrame),
                      SizedBox(height: 24),
                      _buildControls(context),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _buildHeader(BuildContext context, int reps) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
        ),
        
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Text(
                    "$reps",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 48, 
                      fontWeight: FontWeight.bold, 
                      fontFamily: 'Lexend',
                      height: 1.0,
                    ),
                  ),
                  Text(
                    "回数",
                    style: TextStyle(
                      color: kPrimaryColor, 
                      fontSize: 12, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kHighlight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "LIVE",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildFeedback(PoseFrame poseFrame) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: poseFrame.isError ? kHighlight.withOpacity(0.5) : kPrimaryColor.withOpacity(0.5),
              width: 1.5
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (poseFrame.isError ? kHighlight : kPrimaryColor).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(poseFrame.feedbackIcon, color: poseFrame.feedbackColor, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AIコーチ",
                      style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                    SizedBox(height: 2),
                    Text(
                      poseFrame.feedbackText, 
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildControls(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildControlButton(Icons.mic_none, () {}),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ResultScreen(menu: widget.menu)),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kHighlight,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: kHighlight.withOpacity(0.4), blurRadius: 12)],
                  ),
                  child: Icon(Icons.stop, color: Colors.white, size: 32),
                ),
              ),
              SizedBox(width: 16),
              _buildControlButton(Icons.cameraswitch_outlined, () {}),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildControlButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }


  Widget _buildSkeleton(PoseFrame poseFrame) {
    return IgnorePointer(
      child: Container(
        child: CustomPaint(
          size: Size.infinite,
          painter: SkeletonPainter(poseFrame: poseFrame),
        ),
      ),
    );
  }
}


class SkeletonPainter extends CustomPainter {
  final PoseFrame poseFrame;
  SkeletonPainter({required this.poseFrame});


  @override
  void paint(Canvas canvas, Size size) {
    final points = poseFrame.points;
    final pointColors = poseFrame.pointColors;


    final linePaint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
      
    final jointPaint = Paint()
      ..style = PaintingStyle.fill;


    void drawConnection(String k1, String k2) {
      if (points[k1] != null && points[k2] != null) {
        linePaint.color = (pointColors[k1] ?? Colors.white).withOpacity(0.8);
        canvas.drawLine(points[k1]!, points[k2]!, linePaint);
      }
    }


    drawConnection('p1', 'p6');
    drawConnection('p2', 'p3');
    drawConnection('p2', 'p4');
    drawConnection('p3', 'p5');
    drawConnection('p6', 'p7');
    drawConnection('p6', 'p8');
    drawConnection('p7', 'p9');
    drawConnection('p8', 'p10');


    for (var entry in points.entries) {
      final key = entry.key;
      final point = entry.value;
      final color = pointColors[key] ?? kPrimaryColor;
      
      canvas.drawCircle(point, 12, Paint()..color = color.withOpacity(0.3));
      
      jointPaint.color = color;
      canvas.drawCircle(point, 6, jointPaint);
      
      jointPaint.color = Colors.white;
      canvas.drawCircle(point, 2, jointPaint);
    }
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


