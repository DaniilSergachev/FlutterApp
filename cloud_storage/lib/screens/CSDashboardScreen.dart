import 'package:cloud_storage/component/CSDrawerComponents.dart';
import 'package:cloud_storage/component/CSSearchBar.dart';
import 'package:cloud_storage/main.dart';
import 'package:cloud_storage/screens/CSRecentScreen.dart';
import 'package:cloud_storage/screens/CSStarredScreen.dart';
import 'package:cloud_storage/utils/CSColors.dart';
import 'package:cloud_storage/utils/CSConstants.dart';
import 'package:cloud_storage/utils/CSWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CSDashboardScreen extends StatefulWidget {
  static String tag = '/CSDashboardScreen';

  @override
  CSDashboardScreenState createState() => CSDashboardScreenState();
}

class CSDashboardScreenState extends State<CSDashboardScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CSDrawerComponents(),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CSSearchBar(hintText: "Searching in $CSAppName", listData: getCloudboxList),
                      );
                    },
                  )
                ],
                expandedHeight: 120,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text("Home", style: boldTextStyle(size: 20)),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: primaryTextStyle(size: 18),
                    isScrollable: true,
                    tabs: [
                      Tab(text: "Recent"),
                      Tab(text: "Starred"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              CSRecentScreen(),
              CSStarredScreen(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showBottomSheetForAddingData(context);
          setState(() {});
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: CSDarkBlueColor,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      width: double.infinity,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
