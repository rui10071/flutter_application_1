import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'theme.dart';
import 'execution_screen.dart';
import 'training_model.dart';
import 'camera_permission_screen.dart';


class DetailsScreen extends StatefulWidget {
  final TrainingMenu menu;


  DetailsScreen({required this.menu});


  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}


class _DetailsScreenState extends State<DetailsScreen> with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  
  String _selectedTime = '30秒';
  int _selectedSets = 1;


  List<String> _timeOptions = ['30秒', '45秒', '60秒'];
  final List<int> _setOptions = [1, 2, 3, 4, 5];


  @override
  void initState() {
    super.initState();
    
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutQuad),
    );
    _animController.forward();


    String videoPath = "assets/images/${widget.menu.id}.mp4";
    _controller = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0.0);
      }).catchError((error) {});
    
    if (widget.menu.category == "ヨガ" || widget.menu.category == "コア") {
      _timeOptions = ['30秒', '60秒', '90秒'];
      _selectedTime = '60秒';
    } else {
      _timeOptions = ['10回', '12回', '15回'];
      _selectedTime = '10回';
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.menu.isAsset
                ? Image.asset(widget.menu.imagePath, fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: widget.menu.imagePath,
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
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 120),
                      children: [
                        _buildVideoPlayer(),
                        SizedBox(height: 24),
                        _buildInfoCards(),
                        SizedBox(height: 24),
                        _buildGlassSection(
                          title: "概要",
                          child: Text(
                            widget.menu.overview,
                            style: TextStyle(color: Colors.white70, height: 1.6, fontSize: 14),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildSmallGlassInfo(Icons.build, "器具なし")),
                            SizedBox(width: 12),
                            Expanded(child: _buildSmallGlassInfo(Icons.videocam, widget.menu.requiredAngle)),
                          ],
                        ),
                        SizedBox(height: 24),
                        _buildGlassSection(
                          title: "やり方",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.menu.howTo.asMap().entries.map((entry) {
                              return _buildInstructionStep((entry.key + 1).toString(), entry.value);
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildGlassSection(
                          title: "コツ・注意点",
                          child: Column(
                            children: widget.menu.tips.map((tip) => _buildTip(tip)).toList(),
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildTargetBodyParts(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildStartButton(context),
        ],
      ),
    );
  }


  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.menu.title, 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }


  Widget _buildVideoPlayer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            Container(color: Colors.black54),
            if (_controller.value.isInitialized) VideoPlayer(_controller),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoCards() {
    return Row(
      children: [
        _buildDropdownCard("回数/時間", _selectedTime, _timeOptions, (val) {
          setState(() { _selectedTime = val!; });
        }),
        SizedBox(width: 12),
        _buildDropdownCard("セット数", "${_selectedSets} セット", _setOptions.map((s) => "${s} セット").toList(), (val) {
          setState(() { _selectedSets = int.parse(val!.replaceAll(" セット", "")); });
        }),
      ],
    );
  }


  Widget _buildDropdownCard(String title, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Expanded(
      child: _buildGlassContainer(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white54, fontSize: 10)),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                dropdownColor: Color(0xFF1a2c22),
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: kPrimaryColor, size: 16),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildGlassContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }


  Widget _buildSmallGlassInfo(IconData icon, String text) {
    return _buildGlassContainer(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }


  Widget _buildGlassSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        SizedBox(height: 12),
        _buildGlassContainer(child: child),
      ],
    );
  }


  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(number, style: TextStyle(color: kPrimaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 13))),
        ],
      ),
    );
  }


  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: kPrimaryColor, size: 18),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.5))),
        ],
      ),
    );
  }
  
  Widget _buildTargetBodyParts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("鍛えられる部位", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: widget.menu.targetBodyParts.map((part) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Text(part, style: TextStyle(color: Colors.white, fontSize: 12)),
            );
          }).toList(),
        ),
      ],
    );
  }


  Widget _buildStartButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20.0).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () async {
                var status = await Permission.camera.status;
                if (status.isGranted) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ExecutionScreen(menu: widget.menu)));
                } else {
                  var result = await Permission.camera.request();
                  if (result.isGranted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ExecutionScreen(menu: widget.menu)));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPermissionScreen(menu: widget.menu)));
                  }
                }
              },
              child: Text("トレーニング開始", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
            ),
          ),
        ),
      ),
    );
  }
}


