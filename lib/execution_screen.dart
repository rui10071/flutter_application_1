import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'result_screen.dart';
import 'dart:async';
import 'dart:math';
import 'pose_frame.dart';
import 'main_screen.dart';

class ExecutionScreen extends ConsumerStatefulWidget {
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
      "text": "フォームは安定しています",
      "icon": Icons.check_circle,
      "color": kPrimaryColor,
      "isError": false,
      "errorPoint": null,
    },
    {
      "text": "右膝をもう少し曲げましょう",
      "icon": Icons.error,
      "color": kHighlight,
      "isError": true,
      "errorPoint": "p10",
    },
    {
      "text": "背筋はまっすぐです",
      "icon": Icons.check_circle,
      "color": kPrimaryColor,
      "isError": false,
      "errorPoint": null,
    },
    {
      "text": "腰が落ちすぎないように",
      "icon": Icons.error,
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
        } else if (['p4', 'p5', 'p1'].contains(key)) {
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
      body: StreamBuilder<PoseFrame>(
        stream: _poseStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Stack(
              children: [
                Container(color: Colors.black.withOpacity(0.8)),
                Center(child: CircularProgressIndicator(color: kPrimaryColor)),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildHeader(_reps),
                        Spacer(),
                        _buildControls(context),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          
          final poseFrame = snapshot.data!;

          return Stack(
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
              
              _buildSkeleton(poseFrame),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildHeader(poseFrame.reps),
                      Spacer(),
                      _buildFeedback(poseFrame),
                      SizedBox(height: 16),
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

  Widget _buildHeader(int reps) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "$reps",
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

  Widget _buildFeedback(PoseFrame poseFrame) {
    return Column(
      children: [
        _buildFeedbackCard(
          icon: poseFrame.feedbackIcon,
          text: poseFrame.feedbackText,
          color: poseFrame.feedbackColor,
          isError: poseFrame.isError,
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
          SizedBox(width: 8),
          Icon(Icons.volume_up, color: Colors.white.withOpacity(0.7), size: 24),
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
            icon: Icon(Icons.mic, color: Colors.white.withOpacity(0.8), size: 30),
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

    for (var entry in points.entries) {
      final key = entry.key;
      final point = entry.value;
      final paint = Paint()
        ..strokeWidth = 4
        ..color = pointColors[key] ?? kPrimaryColor; 
      
      canvas.drawCircle(point, 8, paint);
    }
    
    _drawLine(canvas, points['p1'], points['p6'], pointColors['p1'] ?? kPrimaryColor);
    _drawLine(canvas, points['p2'], points['p3'], pointColors['p2'] ?? kPrimaryColor);
    _drawLine(canvas, points['p2'], points['p4'], pointColors['p4'] ?? kPrimaryColor);
    _drawLine(canvas, points['p3'], points['p5'], pointColors['p5'] ?? kPrimaryColor);
    _drawLine(canvas, points['p6'], points['p7'], pointColors['p6'] ?? kPrimaryColor);
    _drawLine(canvas, points['p6'], points['p8'], pointColors['p6'] ?? kPrimaryColor);
    _drawLine(canvas, points['p7'], points['p9'], pointColors['p7'] ?? kPrimaryColor);
    _drawLine(canvas, points['p8'], points['p10'], pointColors['p10'] ?? kPrimaryColor);
  }

  void _drawLine(Canvas canvas, Offset? p1, Offset? p2, Color color) {
    if (p1 == null || p2 == null) return;
    final paint = Paint()
      ..strokeWidth = 4
      ..color = color;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

