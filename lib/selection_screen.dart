import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart'; // <--- 追加
import 'theme.dart';
import 'details_screen.dart';
import 'training_model.dart';
import 'main_screen.dart';

// ... (Providerの定義は変更なし) ...
final selectedChipProvider = StateProvider<String>((ref) => "すべて");
final searchQueryProvider = StateProvider<String>((ref) => "");

final filteredTrainingProvider = Provider<List<TrainingMenu>>((ref) {
  final selectedChip = ref.watch(selectedChipProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  List<TrainingMenu> list = DUMMY_TRAININGS;

  if (selectedChip != "すべて") {
    list = list.where((menu) => menu.category == selectedChip).toList();
  }

  if (searchQuery.isNotEmpty) {
    list = list.where((menu) =>
      menu.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
      menu.description.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }
  
  return list;
});


class SelectionScreen extends ConsumerStatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends ConsumerState<SelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _chips = ["すべて", "上半身", "下半身", "コア", "ヨガ"];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _filteredList = ref.watch(filteredTrainingProvider);

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
            child: Column(
              children: [
                _buildSearchBar(context),
                _buildChips(context),
                Expanded(
                  child: _buildGrid(context, _filteredList),
                ),
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

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: kPrimaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildChips(BuildContext context) {
    final _selectedChip = ref.watch(selectedChipProvider);

    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _chips.length,
        itemBuilder: (context, index) {
          final chipName = _chips[index];
          final isSelected = _selectedChip == chipName;
          return Container(
            margin: EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                 ref.read(selectedChipProvider.notifier).state = chipName;
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? kPrimaryColor : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? kPrimaryColor : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Center(
                  child: Text(
                    chipName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<TrainingMenu> _filteredList) {
    if (_filteredList.isEmpty) {
      return Center(
        child: Text(
          "該当するトレーニングはありません",
          style: TextStyle(color: kTextDarkSecondary),
        ),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _filteredList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final item = _filteredList[index];
        final Widget imageWidget;
        
        if (item.isAsset) {
          imageWidget = Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
            );
        } else {
          imageWidget = CachedNetworkImage(
            imageUrl: item.imagePath,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(color: kPrimaryColor, strokeWidth: 2.0),
            ),
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
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: imageWidget,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: TextStyle(fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 2),
                      Text(item.description, style: TextStyle(color: kTextDarkSecondary, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

