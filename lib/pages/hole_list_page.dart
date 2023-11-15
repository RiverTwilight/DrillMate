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
    final projectService = MockProjectService();

    final fetchedProjects = await projectService.fetchHolesByProjectId("asdf");

    setState(() {
      _holes = fetchedProjects;
    });
  }

  Widget _buildTopCard() {
    return Card(
      color: Colors.black45, // Adjust the color for the dimmed effect
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0), // Set your desired radius
        child: Container(
          height: 140, // Adjust the height as needed
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
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: _holes.isNotEmpty
              ? ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _holes.length,
                  itemBuilder: (ctx, i) {
                    if (i == 0) {
                      // The card is placed as the first item
                      return _buildTopCard();
                    }
                    // Adjusting index for holes because of the extra item at the top
                    return HoleItem(
                      hole: _holes[i - 1], // Adjust the index for holes
                      onNavigate: (hole) {
                        // Navigate to HoleDetailPage or perform another action
                      },
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 120),
                      Text(
                        'No holes found', // Update with your actual text
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text('Please add new holes or refresh'),
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
