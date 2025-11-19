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
  final String goal;
  final String sortOrder;


  FilterState({
    this.category = "すべて",
    this.difficulty = "すべて",
    this.goal = "すべて",
    this.sortOrder = "おすすめ順",
  });


  FilterState copyWith({String? category, String? difficulty, String? goal, String? sortOrder}) {
    return FilterState(
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      goal: goal ?? this.goal,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}


final trainingFilterProvider = StateProvider<FilterState>((ref) => FilterState());
final searchQueryProvider = StateProvider<String>((ref) => "");


final filteredTrainingProvider = Provider<List<TrainingMenu>>((ref) {
  final filter = ref.watch(trainingFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider);


  List<TrainingMenu> list = DUMMY_TRAININGS;


  if (searchQuery.isNotEmpty) {
    list = list.where((menu) =>
      menu.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
      menu.description.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }


  if (filter.category != "すべて") {
    list = list.where((menu) => menu.category == filter.category).toList();
  }


  if (filter.difficulty != "すべて") {
    list = list.where((menu) => menu.difficulty.contains(filter.difficulty)).toList();
  }


  if (filter.goal != "すべて") {
    if (filter.goal == "筋トレ") {
      list = list.where((menu) => menu.overview.contains("筋肉") || menu.category != "ヨガ").toList();
    } else if (filter.goal == "健康・ヨガ") {
      list = list.where((menu) => menu.category == "ヨガ" || menu.difficulty == "初級").toList();
    } else if (filter.goal == "ダイエット") {
      list = list.where((menu) => menu.category == "コア" || menu.id == "hiit").toList();
    }
  }


  if (filter.sortOrder == "時間が短い順") {
    list.sort((a, b) => _parseDuration(a.duration).compareTo(_parseDuration(b.duration)));
  } else if (filter.sortOrder == "時間が長い順") {
    list.sort((a, b) => _parseDuration(b.duration).compareTo(_parseDuration(a.duration)));
  }


  return list;
});


int _parseDuration(String duration) {
  return int.tryParse(duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
}


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
    final _searchQuery = ref.watch(searchQueryProvider);
    final _currentFilter = ref.watch(trainingFilterProvider);
    
    bool isFilterActive = _currentFilter.category != "すべて" || 
                          _currentFilter.difficulty != "すべて" || 
                          _currentFilter.goal != "すべて";


    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, ref),
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
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
                  SliverToBoxAdapter(child: _buildSearchBar(context, ref, isFilterActive)),
                  
                  if (_searchQuery.isEmpty && !isFilterActive) ...[
                    SliverToBoxAdapter(child: _buildFeaturedSection(context)),
                    SliverToBoxAdapter(child: SizedBox(height: 32)),
                    SliverToBoxAdapter(child: _buildRankingSection(context)),
                    SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],


                  if (isFilterActive)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                        child: Row(
                          children: [
                            Icon(Icons.filter_list, size: 16, color: kPrimaryColor),
                            SizedBox(width: 8),
                            Text(
                              "検索結果: ${_filteredList.length}件", 
                              style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontFamily: 'Lexend')
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () => ref.refresh(trainingFilterProvider),
                              child: Text("リセット", style: TextStyle(color: Colors.white54, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
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
        "トレーニング", 
        style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)
      ),
    );
  }


  Widget _buildSearchBar(BuildContext context, WidgetRef ref, bool isFilterActive) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        children: [
          Expanded(
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
                    hintText: "トレーニングを検索...",
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
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              _showFilterModal(context, ref);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: isFilterActive ? kPrimaryColor.withOpacity(0.8) : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Icon(
                    Icons.tune, 
                    color: isFilterActive ? Colors.white : Colors.white70,
                    size: 20
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _showFilterModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterModal(),
    );
  }


  Widget _buildFeaturedSection(BuildContext context) {
    final featuredItem = DUMMY_TRAININGS.firstWhere((m) => m.id == "hiit", orElse: () => DUMMY_TRAININGS.first);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text("今週のトレンド", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: featuredItem)));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: featuredItem.isAsset 
                      ? Image.asset(featuredItem.imagePath, fit: BoxFit.cover)
                      : CachedNetworkImage(imageUrl: featuredItem.imagePath, fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                          stops: [0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text("PICK UP", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                        ),
                        SizedBox(height: 8),
                        Text(featuredItem.title, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(featuredItem.description, style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildRankingSection(BuildContext context) {
    final rankingItems = DUMMY_TRAININGS.take(5).toList();


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("人気ランキング", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
              Icon(Icons.emoji_events_outlined, color: Colors.amber, size: 20),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemCount: rankingItems.length,
            itemBuilder: (context, index) {
              final item = rankingItems[index];
              return _buildRankingCard(context, item, index + 1);
            },
          ),
        ),
      ],
    );
  }


  Widget _buildRankingCard(BuildContext context, TrainingMenu item, int rank) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: item)));
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: item.isAsset 
                        ? AssetImage(item.imagePath) as ImageProvider
                        : NetworkImage(item.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Center(
                          child: Text(
                            "$rank",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(item.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(item.difficulty, style: TextStyle(fontSize: 10, color: Colors.white54)),
          ],
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
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = _filteredList[index];
            final Widget imageWidget = item.isAsset
                ? Image.asset(item.imagePath, fit: BoxFit.cover, width: double.infinity)
                : CachedNetworkImage(
                    imageUrl: item.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Container(color: Color(0xFF122017)),
                    errorWidget: (context, url, error) => Icon(Icons.error, color: kHighlight),
                  );
                
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: item)));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(child: imageWidget),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                            stops: [0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    if (item.difficulty == "上級")
                      Positioned(
                        right: 12,
                        top: 12,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              color: Colors.red.withOpacity(0.6),
                              child: Text("上級", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time, color: kPrimaryColor, size: 12),
                              SizedBox(width: 4),
                              Text(item.duration, style: TextStyle(color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: _filteredList.length,
        ),
      ),
    );
  }
}


class _FilterModal extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(trainingFilterProvider);


    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Color(0xFF122017).withOpacity(0.9),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(24),
                  children: [
                    _buildFilterSection(
                      context, 
                      title: "カテゴリ",
                      options: ["すべて", "上半身", "下半身", "コア", "ヨガ"],
                      selectedValue: filterState.category,
                      onSelected: (val) => ref.read(trainingFilterProvider.notifier).state = filterState.copyWith(category: val),
                    ),
                    SizedBox(height: 32),
                    _buildFilterSection(
                      context, 
                      title: "難易度",
                      options: ["すべて", "初級", "中級", "上級"],
                      selectedValue: filterState.difficulty,
                      onSelected: (val) => ref.read(trainingFilterProvider.notifier).state = filterState.copyWith(difficulty: val),
                    ),
                    SizedBox(height: 32),
                    _buildFilterSection(
                      context, 
                      title: "目的",
                      options: ["すべて", "筋トレ", "ダイエット", "健康・ヨガ"],
                      selectedValue: filterState.goal,
                      onSelected: (val) => ref.read(trainingFilterProvider.notifier).state = filterState.copyWith(goal: val),
                    ),
                    SizedBox(height: 32),
                    Text("並び替え", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 14)),
                    SizedBox(height: 16),
                    _buildSortDropdown(context, ref, filterState),
                  ],
                ),
              ),
              _buildFooter(context, ref),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("絞り込み検索", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }


  Widget _buildFilterSection(BuildContext context, {required String title, required List<String> options, required String selectedValue, required Function(String) onSelected}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 14)),
        SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? kPrimaryColor : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? kPrimaryColor : Colors.white.withOpacity(0.1)),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }


  Widget _buildSortDropdown(BuildContext context, WidgetRef ref, FilterState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.sortOrder,
          dropdownColor: Color(0xFF1a2c22),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          items: ["おすすめ順", "時間が短い順", "時間が長い順"].map((String val) {
            return DropdownMenuItem(
              value: val,
              child: Text(val, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(trainingFilterProvider.notifier).state = state.copyWith(sortOrder: val);
            }
          },
        ),
      ),
    );
  }


  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                ref.read(trainingFilterProvider.notifier).state = FilterState();
              },
              child: Text("リセット", style: TextStyle(color: Colors.white54)),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("適用する", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}


