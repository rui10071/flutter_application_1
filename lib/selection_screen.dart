import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/bottom_nav_bar.dart';
import 'details_screen.dart';

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(bottom: 100),
              children: [
                _buildAppBar(context),
                _buildSearchBar(context),
                _buildChips(),
                _buildGrid(context),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomNavBar(currentIndex: 1),
            ),
          ],
        ),
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
        decoration: InputDecoration(
          hintText: "トレーニングを検索",
          hintStyle: TextStyle(color: kTextDarkSecondary),
          prefixIcon: Icon(Icons.search, color: kTextDarkSecondary),
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

  Widget _buildChips() {
    final chips = ["すべて", "上半身", "下半身", "コア", "ヨガ"];
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            margin: EdgeInsets.only(right: 8),
            child: Chip(
              label: Text(chips[index]),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: isSelected ? kPrimaryColor : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200]),
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

  Widget _buildGrid(BuildContext context) {
    final items = [
      {"title": "15分間上半身強化", "desc": "15分・中級", "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuBCBqVhQvC9y9qSiPRFmLUQp9CatnnIr1Di6W3dDnWk7_5CMpZkKNTysrlBAT6YlQ--WbDWp1JHxDOALKZVGXBVD8TMnkQn0R6V8fwq3NvWcXvR1KU0I4J5t3dmF9N7-GiCLD_WV4d7AVdEN5AWMyDtpR4_SjavnmBJqBPmJUMVANxyUHPDzUP09wbmBqF4E6OafEbhjzWuTTUJKcPVuU3lo0AADJkA6mUV5gbB8L3pDBannbT_kD5FQLpMFtSY-4QyfHud7nSlO3I"},
      {"title": "20分間下半身集中", "desc": "20分・上級", "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuAM7ODQIFSGjVO_HOrRDmZBn5bSNJCGFcaqW87hPflDhJnNdqHkySER71nFmynzv-fcL61pxiikYnMXosV_pf1LKVu-PLWrcDFVvunB_WYxckyOsh_r1Shh0e3qzFC9hjhAJMnfNAlfP8_feVmIO5phechh_3B8gfeFeUtN6ByijJnN5q7yMqf_K3wSTx-k6z2fUaB3EMbUUafOVQLT6idTiywcQVe1Y58fXZF9oBObitxFhGvxeGE4ehLQ_o-K12GdSiC6cUQYvQw"},
      {"title": "30分間ヨガフロー", "desc": "30分・初級", "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDSzLYxOvzHDSdgqV9guEvoXQDpUr2W04AYBVYEAB45T__qdMczDAJA1r-cFdoYD1x3gkg4LE7eI7Re73Sb4YpdN6du60YLuW9KyWVwP00xSQQbcWoa89vOcClFxnxfKdommu5DMpMCu9gC0jN9tpaIQuU7InuPcprosS3P2I_n6nMGq2x-1Kbv760e21GMCtrt21c6_gSLqu1OYWEa83T3XbAFlED42wuBrnaPhlYUFMQ1P-0Ye2jJ8RyhLzqt1iTo_CgPbehW66g"},
      {"title": "10分間全身ワークアウト", "desc": "10分・中級", "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDcv3mnUvd5KONbCJuSmDlvq6Ijh_aFTxznXv0QKQuOFvpxkxUTuyug8_FXV_B7fuC2B1CKAp44nFxf_gaPnIGnb5BP1dubTBV_O1gR-yAo-Pu2HGt_6mTfNWZEOTauLEMH66zpSijOviAGfCUt3yTT5tdn5zUPSsG31AqgJgpHSmCchTbkZVCY94gt080m93if2J2NNQ98hd-E3PN8ucf0AFuKKDkVYXSh6Tt1Bi1B7xRc7crEJMkqzos7T_9rqbny2-6UPKJJNGE"},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen()));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      items[index]["image"]!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(items[index]["title"]!, style: TextStyle(fontWeight: FontWeight.w500)),
                Text(items[index]["desc"]!, style: TextStyle(color: kTextDarkSecondary, fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );
  }
}

