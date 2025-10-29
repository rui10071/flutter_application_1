import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'theme.dart';
import 'execution_screen.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late VideoPlayerController _controller;
  String _selectedTime = '30秒';
  int _selectedSets = 1;
  int _calculatedCalories = 50;

  final List<String> _timeOptions = ['30秒', '45秒', '60秒'];
  final List<int> _setOptions = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://assets.mixkit.co/videos/preview/mixkit-man-doing-push-ups-at-the-gym-2287-large.mp4'))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0.0);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _recalculateCalories() {
    int timeInSeconds = 30;
    if (_selectedTime == '45秒') timeInSeconds = 45;
    if (_selectedTime == '60秒') timeInSeconds = 60;

    double baseCalories = (timeInSeconds / 30.0) * 50.0;
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
                    "プッシュアップは、主に大胸筋、上腕三頭筋、三角筋を鍛える自重トレーニングです。体幹の安定性も向上させます。",
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
                          Text("正面", style: TextStyle(fontWeight: FontWeight.w500)),
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
                        children: [
                          _buildInstructionStep("1", "四つん這いになり、肩の真下に手を、腰の真下に膝を置きます。"),
                          _buildInstructionStep("2", "脚をまっすぐ後ろに伸ばし、頭からかかとまでが一直線になるようにします。"),
                          _buildInstructionStep("3", "息を吸いながら、肘を曲げて胸を床に近づけます。"),
                          _buildInstructionStep("4", "息を吐きながら、手のひらで床を押し、体を元の位置に戻します。"),
                        ],
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
                      children: [
                        _buildTip("常にお腹に力を入れ、腰が反ったり丸まったりしないように意識しましょう。"),
                        _buildTip("動作はゆっくりと、筋肉の収縮を意識しながら行いましょう。"),
                      ],
                    ),
                  ),
                ),
                _buildSection(context, title: "鍛えられる部位",
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.network("https://lh3.googleusercontent.com/aida-public/AB6AXuBafCyUVI6JjmNiMQ4SW07LEHlGAwcTnolSHphbt6XTQPle41lbCqW5vg9zg7vi6VCU5Yna5zRtGVnTp3MZFDIJTMsws2NOB_BUGLOvmVhvB7efBoVjkiD0_P-EpI5NXzP6OwkIdXc116_cSwWiLrOHq_JHZKqlix59WuaE6A6lu7TsnLuILd08Fhn7bGDmTEgxJ0wDXvSqP5VsI7fvqnPCqNIfGDJespeyvAnIr-M3_wOUmUabFl0MHAvtQe7ueoTC_ntom9ZQfKg", height: 192),
                          Image.network("https://lh3.googleusercontent.com/aida-public/AB6AXuASitX4LEzquy9mPpG-gh_H_A4oxLobS6xalJ74eqoPykdgcqBn1SYBiEe-WuSPW87EwMHJOeY1xFkC2rgz95qS0GRASam4F2nxT_vJf6oWCa01O5-uzvWH2sDFXG47uNB6pg63IeJmFkPp-whUhl-jR7gEKmkH45xaouW82YHxWF-YG2N6LWlKaJ1xL7CW7Gvj05ZhGFEjsJq7SLwn5bfH9dtirujRnZV5nH4-irLQ2drMo16NoKTvd1e7bd7VRiVvvEwGzlFEW_4", height: 192),
                        ],
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
          Text("プッシュアップ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
          _buildDropdownCard("時間", _selectedTime, _timeOptions, (val) {
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
    final items = [
        {"title": "体幹プランク", "desc": "1分 | 初級", "image": "https://images.unsplash.com/photo-1599058917212-d750089bc07e?q=80&w=2938&auto=format&fit=crop"},
        {"title": "基本のスクワット", "desc": "15回 | 初級", "image": "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?q=80&w=2940&auto=format&fit=crop"},
        {"title": "肩のストレッチ", "desc": "5分 | 全レベル", "image": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=2940&auto=format&fit=crop"},
    ];
    
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
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                width: 192,
                margin: EdgeInsets.only(right: 16),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        items[index]["image"]!,
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(items[index]["title"]!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 2),
                            Text(items[index]["desc"]!, style: TextStyle(color: kTextDarkSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
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
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ExecutionScreen()));
          },
          child: Text("トレーニング開始"),
        ),
      ),
    );
  }
}

