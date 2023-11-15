import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/models/hole.dart';
import 'package:hgeology_app/pages/new_point_page.dart';
import 'package:hgeology_app/pages/search_page.dart';
import 'package:hgeology_app/services/project_service.dart';
import 'package:hgeology_app/widget/point_item.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/gen/strings.g.dart';

/// Show the holes belongs to certain prioject
class HoleListPage extends ConsumerStatefulWidget {
  const HoleListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HoleListPage> createState() => _HoleListPageState();
}

class _HoleListPageState extends ConsumerState<HoleListPage> {
  String dropdownValue = 'Recently';
  List<Hole> _holes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("测试项目"),
      leading: const LeadingBackButton(),
      actions: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search))
      ],
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    final projectService = MockProjectService();

    final fetchedProjects = await projectService.fetchHolesByProjectId("asdf");

    setState(() {
      _holes = fetchedProjects;
      _isLoading = false;
    });
  }

  Widget _buildTopCard() {
    return Card(
      color: Colors.black45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/artwork/blue.jpeg'), // Replace with your artwork asset
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.1), // Dimming effect
                BlendMode.darken,
              ),
            ),
          ),
          child: Center(
            child: Text(
              '勘探点', // Replace with your title
              style: TextStyle(
                fontSize: 24, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: _holes.isNotEmpty
              ? ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _holes.length,
                  itemBuilder: (ctx, i) {
                    if (i == 0) {
                      return _buildTopCard();
                    }
                    return HoleItem(
                      hole: _holes[i - 1],
                      onNavigate: (hole) {
                        // Navigate to HoleDetailPage or perform another action
                      },
                    );
                  },
                )
              : _isLoading
                  ? Container()
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 120),
                          Text(
                            '暂时没有勘探点',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text('你可以添加更多勘探点，或者稍后再来查看。'),
                        ],
                      ),
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewPointPage(),
            ),
          );
        },
      ),
    );
  }
}
