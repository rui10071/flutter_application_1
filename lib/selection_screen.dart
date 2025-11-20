import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'theme.dart';
import 'details_screen.dart';
import 'training_model.dart';
import 'main_screen.dart';


class FilterState {
  final String category;
  final String difficulty;
  final String bodyPart; 


  FilterState({
    this.category = "すべて",
    this.difficulty = "すべて",
    this.bodyPart = "すべて",
  });


  FilterState copyWith({String? category, String? difficulty, String? bodyPart}) {
    return FilterState(
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      bodyPart: bodyPart ?? this.bodyPart,
    );
  }
}


final trainingFilterProvider = StateProvider<FilterState>((ref) => FilterState());
final searchQueryProvider = StateProvider<String>((ref) => "");


final filteredTrainingProvider = Provider<List<TrainingMenu>>((ref) {
  final filter = ref.watch(trainingFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider);


  List<TrainingMenu> list = DUMMY_TRAININGS;


  // 検索フィルタ
  if (searchQuery.isNotEmpty) {
    final query = searchQuery.toLowerCase();
    list = list.where((menu) =>
      menu.title.toLowerCase().contains(query) ||
      menu.titleEn.toLowerCase().contains(query) ||
      menu.searchKeywords.any((k) => k.toLowerCase().contains(query))
    ).toList();
  }


  // カテゴリフィルタ（ダンベル/自重など）
  if (filter.category != "すべて") {
    // ※今回は簡易的に判定。本来はDBに種別を持たせる
    if (filter.category == "自重") {
      list = list.where((menu) => ["squat", "pushup"].contains(menu.id)).toList();
    } else if (filter.category == "ダンベル") {
      list = list.where((menu) => ["armcurl", "sidelaterals", "shoulderpress"].contains(menu.id)).toList();
    }
  }


  // 部位フィルタ
  if (filter.bodyPart != "すべて") {
    list = list.where((menu) => menu.targetBodyParts.any((part) => part.contains(filter.bodyPart) || menu.category.contains(filter.bodyPart))).toList();
  }


  // 難易度フィルタ
  if (filter.difficulty != "すべて") {
    list = list.where((menu) => menu.difficulty == filter.difficulty).toList();
  }


  return list;
});


class SelectionScreen extends ConsumerStatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}


class _SelectionScreenState extends ConsumerState<SelectionScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
    _controller.forward();
  }


  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final _filteredList = ref.watch(filteredTrainingProvider);
    
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, ref),
      body: Stack(
        children: [
          Positioned.fill(
             child: Container(color: Colors.black), 
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.9),
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildSearchBar(context, ref)),
                  SliverToBoxAdapter(child: _buildFilterButtons(context, ref)),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  _buildGrid(context, _filteredList),
                  SliverToBoxAdapter(child: SizedBox(height: 120)), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  AppBar _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          ref.read(mainNavIndexProvider.notifier).state = 0;
        },
      ),
      title: Text(
        "トレーニング選択", 
        style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)
      ),
    );
  }


  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            decoration: InputDecoration(
              hintText: "種目を検索...",
              hintStyle: TextStyle(color: Colors.white38),
              prefixIcon: Icon(Icons.search, color: Colors.white54, size: 20),
              suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.white54, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = "";
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildFilterButtons(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(trainingFilterProvider);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildDropdownButton(
            context, 
            "すべて", 
            ["すべて", "自重", "ダンベル"], 
            filter.category,
            (val) => ref.read(trainingFilterProvider.notifier).state = filter.copyWith(category: val)
          ),
          SizedBox(width: 12),
          _buildDropdownButton(
            context, 
            "部位", 
            ["すべて", "腕", "肩", "胸", "背中", "下半身"], 
            filter.bodyPart,
            (val) => ref.read(trainingFilterProvider.notifier).state = filter.copyWith(bodyPart: val)
          ),
          SizedBox(width: 12),
          _buildDropdownButton(
            context, 
            "難易度", 
            ["すべて", "初級", "中級", "上級"], 
            filter.difficulty,
            (val) => ref.read(trainingFilterProvider.notifier).state = filter.copyWith(difficulty: val)
          ),
        ],
      ),
    );
  }


  Widget _buildDropdownButton(BuildContext context, String label, List<String> items, String currentValue, Function(String) onChanged) {
    final isSelected = currentValue != items[0];
    
    return Container(
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? kPrimaryColor : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isSelected ? kPrimaryColor : Colors.white.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(currentValue) ? currentValue : items[0],
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value == items[0] ? label : value,
                style: TextStyle(
                  fontSize: 13, 
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.white
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          dropdownColor: Color(0xFF1a2c22),
          icon: Icon(Icons.arrow_drop_down, color: isSelected ? Colors.black : Colors.white70, size: 18),
          isDense: true,
        ),
      ),
    );
  }


  Widget _buildGrid(BuildContext context, List<TrainingMenu> _filteredList) {
    if (_filteredList.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.search_off, color: Colors.white24, size: 48),
                SizedBox(height: 16),
                Text(
                  "該当するトレーニングはありません",
                  style: TextStyle(color: Colors.white38),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 20,
          childAspectRatio: 2.2,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = _filteredList[index];
            return _buildTrainingCard(context, item);
          },
          childCount: _filteredList.length,
        ),
      ),
    );
  }


  Widget _buildTrainingCard(BuildContext context, TrainingMenu item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: item)));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: item.isAsset
                  ? Image.asset(item.imagePath, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: item.imagePath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Color(0xFF122017)),
                      errorWidget: (context, url, error) => Icon(Icons.error, color: kHighlight),
                    ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                    stops: [0.0, 0.8],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            _buildTag(item.category),
                            SizedBox(width: 8),
                            _buildTag(item.difficulty, isOutline: true),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          item.title,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                        ),
                        SizedBox(height: 4),
                        Text(
                          item.targetBodyParts.join(", "),
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: kPrimaryColor, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTag(String text, {bool isOutline = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : kPrimaryColor,
        borderRadius: BorderRadius.circular(4),
        border: isOutline ? Border.all(color: Colors.white38) : null,
      ),
      child: Text(
        text, 
        style: TextStyle(
          color: isOutline ? Colors.white70 : Colors.black, 
          fontSize: 10, 
          fontWeight: FontWeight.bold
        )
      ),
    );
  }
}




