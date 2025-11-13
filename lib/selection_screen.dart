import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'theme.dart';
import 'details_screen.dart';
import 'training_model.dart';
import 'main_screen.dart';


// フィルター状態を管理するクラス
class FilterState {
  final String category;
  final String difficulty;
  final String goal;
  final String sortOrder; // default, duration_asc, duration_desc


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


  // テキスト検索
  if (searchQuery.isNotEmpty) {
    list = list.where((menu) =>
      menu.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
      menu.description.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }


  // カテゴリフィルター
  if (filter.category != "すべて") {
    list = list.where((menu) => menu.category == filter.category).toList();
  }


  // 難易度フィルター
  if (filter.difficulty != "すべて") {
    list = list.where((menu) => menu.difficulty.contains(filter.difficulty)).toList();
  }


  // 目的フィルター（簡易的なキーワードマッチング）
  if (filter.goal != "すべて") {
    if (filter.goal == "筋トレ") {
      list = list.where((menu) => menu.overview.contains("筋肉") || menu.category != "ヨガ").toList();
    } else if (filter.goal == "健康・ヨガ") {
      list = list.where((menu) => menu.category == "ヨガ" || menu.difficulty == "初級").toList();
    } else if (filter.goal == "ダイエット") {
      list = list.where((menu) => menu.category == "コア" || menu.id == "hiit").toList();
    }
  }


  // ソート処理
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


class _SelectionScreenState extends ConsumerState<SelectionScreen> {
  final TextEditingController _searchController = TextEditingController();


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final _filteredList = ref.watch(filteredTrainingProvider);
    final _searchQuery = ref.watch(searchQueryProvider);
    final _currentFilter = ref.watch(trainingFilterProvider);
    
    // フィルターがアクティブかどうか（バッジ表示用）
    bool isFilterActive = _currentFilter.category != "すべて" || 
                          _currentFilter.difficulty != "すべて" || 
                          _currentFilter.goal != "すべて";


    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, ref),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kPrimaryColor.withOpacity(0.5), kBackgroundDark],
                stops: [0.0, 0.3],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildSearchBar(context, ref, isFilterActive)),
                
                if (_searchQuery.isEmpty && !isFilterActive) ...[
                  SliverToBoxAdapter(child: _buildFeaturedSection(context)),
                  SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(child: _buildRankingSection(context)),
                  SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],


                if (isFilterActive)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list, size: 16, color: kPrimaryColor),
                          SizedBox(width: 8),
                          Text(
                            "絞り込み結果: ${_filteredList.length}件", 
                            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)
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
                
                SliverToBoxAdapter(child: SizedBox(height: 100)), 
              ],
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
      title: Text("トレーニング", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }


  Widget _buildSearchBar(BuildContext context, WidgetRef ref, bool isFilterActive) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: "トレーニングを検索",
                hintStyle: TextStyle(color: kTextDarkSecondary),
                prefixIcon: Icon(Icons.search, color: kTextDarkSecondary, size: 20),
                suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: kTextDarkSecondary, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = "";
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              _showFilterModal(context, ref);
            },
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: isFilterActive ? kPrimaryColor : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isFilterActive ? kPrimaryColor : Colors.white.withOpacity(0.1)),
              ),
              child: Icon(
                Icons.tune, 
                color: isFilterActive ? Colors.white : Colors.white70,
                size: 24
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("今週のトレンド", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: featuredItem)));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: featuredItem.isAsset 
                  ? AssetImage(featuredItem.imagePath) as ImageProvider
                  : NetworkImage(featuredItem.imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text("PICK UP", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 8),
                      Text(featuredItem.title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(featuredItem.description, style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("人気ランキング", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
              Icon(Icons.emoji_events_outlined, color: Colors.amber, size: 20),
            ],
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
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
        width: 140,
        margin: EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: item.isAsset 
                        ? AssetImage(item.imagePath) as ImageProvider
                        : NetworkImage(item.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: rank == 1 ? Colors.amber : (rank == 2 ? Colors.grey[300] : (rank == 3 ? Colors.brown[300] : Colors.black54)),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                    ),
                    child: Center(
                      child: Text(
                        "$rank",
                        style: TextStyle(color: rank <= 3 ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(item.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(item.difficulty, style: TextStyle(fontSize: 10, color: kTextDarkSecondary)),
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
            child: Text(
              "該当するトレーニングはありません",
              style: TextStyle(color: kTextDarkSecondary),
            ),
          ),
        ),
      );
    }
    
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = _filteredList[index];
            final Widget imageWidget;
            
            if (item.isAsset) {
              imageWidget = Image.asset(
                  item.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
            } else {
              imageWidget = CachedNetworkImage(
                imageUrl: item.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(color: Colors.grey[800]),
                errorWidget: (context, url, error) => Icon(Icons.error, color: kHighlight),
              );
            }
                
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: item)));
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(child: imageWidget),
                          if (item.difficulty == "上級")
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text("上級", style: TextStyle(color: kHighlight, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: TextStyle(fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 2),
                          Text(item.description, style: TextStyle(color: kTextDarkSecondary, fontSize: 12)),
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


    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  title: "部位・カテゴリ",
                  options: ["すべて", "上半身", "下半身", "コア", "ヨガ"],
                  selectedValue: filterState.category,
                  onSelected: (val) => ref.read(trainingFilterProvider.notifier).state = filterState.copyWith(category: val),
                ),
                SizedBox(height: 24),
                _buildFilterSection(
                  context, 
                  title: "難易度",
                  options: ["すべて", "初級", "中級", "上級"],
                  selectedValue: filterState.difficulty,
                  onSelected: (val) => ref.read(trainingFilterProvider.notifier).state = filterState.copyWith(difficulty: val),
                ),
                SizedBox(height: 24),
                _buildFilterSection(
                  context, 
                  title: "目的",
                  options: ["すべて", "筋トレ", "ダイエット", "健康・ヨガ"],
                  selectedValue: filterState.goal,
                  onSelected: (val) => ref.read(trainingFilterProvider.notifier).state = filterState.copyWith(goal: val),
                ),
                SizedBox(height: 24),
                Text("並び替え", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: kTextDarkSecondary)),
                SizedBox(height: 12),
                _buildSortDropdown(context, ref, filterState),
              ],
            ),
          ),
          _buildFooter(context, ref),
        ],
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("検索条件の絞り込み", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(Icons.close, color: kTextDarkSecondary),
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
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: kTextDarkSecondary)),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) onSelected(option);
              },
              selectedColor: kPrimaryColor,
              backgroundColor: Colors.white.withOpacity(0.05),
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.w500),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.transparent)),
            );
          }).toList(),
        ),
      ],
    );
  }


  Widget _buildSortDropdown(BuildContext context, WidgetRef ref, FilterState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.sortOrder,
          dropdownColor: Color(0xFF1a2c22),
          isExpanded: true,
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
              child: Text("リセット", style: TextStyle(color: kTextDarkSecondary)),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("結果を表示"),
            ),
          ),
        ],
      ),
    );
  }
}


