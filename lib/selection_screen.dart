import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'details_screen.dart';
import 'training_model.dart';
import 'main_screen.dart';

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
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(context, ref),
            _buildSearchBar(context),
            _buildChips(context),
            Expanded(
              child: _buildGrid(context, _filteredList),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyLarge?.color),
            onPressed: () {
              ref.read(mainNavIndexProvider.notifier).state = 0;
            },
          ),
          Text("トレーニング", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        decoration: InputDecoration(
          hintText: "トレーニングを検索",
          hintStyle: TextStyle(color: kTextDarkSecondary),
          prefixIcon: Icon(Icons.search, color: kTextDarkSecondary),
          suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: kTextDarkSecondary),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).state = "";
                  },
                )
              : null,
          filled: true,
          fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
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
            child: ChoiceChip(
              label: Text(chipName),
              selected: isSelected,
              onSelected: (selected) {
                ref.read(selectedChipProvider.notifier).state = chipName;
              },
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: (Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200]),
              selectedColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.transparent),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
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
        final Widget imageWidget = item.isAsset
          ? Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
            )
          : Image.network(
              item.imagePath,
              fit: BoxFit.cover,
            );
            
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: item)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageWidget,
                ),
              ),
              SizedBox(height: 8),
              Text(item.title, style: TextStyle(fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,),
              Text(item.description, style: TextStyle(color: kTextDarkSecondary, fontSize: 14)),
            ],
          ),
        );
      },
    );
  }
}

