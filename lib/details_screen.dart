import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
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


class _DetailsScreenState extends State<DetailsScreen> {
  late VideoPlayerController _controller;
  String _selectedTime = '30秒';
  int _selectedSets = 1;
  int _calculatedCalories = 50;


  List<String> _timeOptions = ['30秒', '45秒', '60秒'];
  final List<int> _setOptions = [1, 2, 3, 4, 5];


  @override
  void initState() {
    super.initState();
    
    String videoPath = "assets/images/${widget.menu.id}.mp4";
    _controller = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0.0);
      }).catchError((error) {
        print("動画の読み込みに失敗しました: $videoPath");

      });
    
    if (widget.menu.category == "ヨガ" || widget.menu.category == "コア") {
      _timeOptions = ['30秒', '60秒', '90秒'];
      _selectedTime = '60秒';
    } else {
      _timeOptions = ['10回', '12回', '15回'];
      _selectedTime = '10回';
    }
    _recalculateCalories();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void _recalculateCalories() {
    double baseCalories = 50.0;
    setState(() {
      _calculatedCalories = (baseCalories * _selectedSets).round();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: ListView(
              padding: EdgeInsets.only(bottom: 120),
              children: [
                _buildAppBar(context),
                _buildVideoPlayer(),
                _buildInfoCards(),
                _buildSection(context, title: "概要",
                  child: Text(
                    widget.menu.overview,
                    style: TextStyle(color: kTextDarkSecondary, height: 1.6),
                  ),
                ),
                _buildSection(context, title: "必要な器具",
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.sentiment_very_satisfied, color: kPrimaryColor),
                          SizedBox(width: 12),
                          Text("器具は必要ありません", style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
                 _buildSection(context, title: "推奨アングル",
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.videocam_outlined, color: kPrimaryColor),
                          SizedBox(width: 12),
                          Text(widget.menu.requiredAngle, style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildSection(context, title: "やり方",
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.menu.howTo.asMap().entries.map((entry) {
                          return _buildInstructionStep((entry.key + 1).toString(), entry.value);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                _buildSection(context, title: "コツ・注意点",
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(left: BorderSide(color: kPrimaryColor, width: 4)),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: widget.menu.tips.map((tip) => _buildTip(tip)).toList(),
                    ),
                  ),
                ),
                _buildSection(context, title: "鍛えられる部位",
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: widget.menu.targetBodyParts.map((part) {
                          return Chip(
                            label: Text(part),
                            backgroundColor: kPrimaryColor.withOpacity(0.1),
                            labelStyle: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
                            side: BorderSide(color: kPrimaryColor.withOpacity(0.3)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                _buildRelatedWorkouts(context),
              ],
            ),
          ),
          _buildStartButton(context),
        ],
      ),
    );
  }


  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyLarge?.color),
            onPressed: () => Navigator.pop(context),
          ),
          Text(widget.menu.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(width: 48),
        ],
      ),
    );
  }


  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.grey[800],
        child: _controller.value.isInitialized
            ? VideoPlayer(_controller)
            : Center(child: CircularProgressIndicator(color: kPrimaryColor)),
      ),
    );
  }


  Widget _buildInfoCards() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildDropdownCard("回数/時間", _selectedTime, _timeOptions, (val) {
            setState(() { _selectedTime = val!; _recalculateCalories(); });
          }),
          SizedBox(width: 16),
           _buildDropdownCard("セット", "${_selectedSets}セット", _setOptions.map((s) => "${s}セット").toList(), (val) {
            setState(() { _selectedSets = int.parse(val!.replaceAll("セット", "")); _recalculateCalories(); });
          }),
          SizedBox(width: 16),
          _buildInfoCard("消費カロリー", "$_calculatedCalories kcal"),
        ],
      ),
    );
  }
  
  Widget _buildInfoCard(String title, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: kTextDarkSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
              SizedBox(height: 4),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDropdownCard(String title, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: kTextDarkSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
              Container(
                height: 30,
                child: DropdownButton<String>(
                  value: value,
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: onChanged,
                  underline: Container(),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }


  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$number. ", style: TextStyle(color: kTextDarkSecondary, height: 1.6)),
          Expanded(child: Text(text, style: TextStyle(color: kTextDarkSecondary, height: 1.6))),
        ],
      ),
    );
  }


  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: kPrimaryColor, size: 18),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
  
  Widget _buildRelatedWorkouts(BuildContext context) {
    final relatedItems = DUMMY_TRAININGS
        .where((menu) => menu.id != widget.menu.id)
        .take(3)
        .toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("こちらもおすすめ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 12),
        Container(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: relatedItems.length,
            itemBuilder: (context, index) {
              final item = relatedItems[index];
              final Widget imageWidget = item.isAsset
                ? Image.asset(
                    item.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    item.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );


              return Container(
                width: 192,
                margin: EdgeInsets.only(right: 16),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DetailsScreen(menu: item)),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: imageWidget,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 2),
                              Text(item.description, style: TextStyle(color: kTextDarkSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildStartButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1)),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
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
          child: Text("トレーニング開始"),
        ),
      ),
    );
  }
}


