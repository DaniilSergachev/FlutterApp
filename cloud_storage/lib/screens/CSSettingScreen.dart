import 'package:cloud_storage/screens/CSStartingScreen.dart';
import 'package:cloud_storage/utils/CSColors.dart';
import 'package:cloud_storage/utils/CSConstants.dart';
import 'package:cloud_storage/utils/CSWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CSSettingScreen extends StatefulWidget {
  static String tag = '/CSSettingScreen';

  @override
  CSSettingScreenState createState() => CSSettingScreenState();
}

class CSSettingScreenState extends State<CSSettingScreen> {
  bool offlineFiles = false;
  bool syncContacts = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  finish(context);
                },
              ),
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(title: Text("$CSAppName settings", style: boldTextStyle())),
            ),
          ];
        },
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Account", style: boldTextStyle(size: 14)).paddingOnly(top: 10, left: 16),
                    buildDivider(),
                    ListTile(
                      onTap: () {
                        showBottomSheetForUpdatePhoto(context);
                      },
                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                      title: Text("Personal", style: boldTextStyle()),
                      subtitle: Text("$CSAppName Basic"),
                      leading: CircleAvatar(backgroundColor: CSDarkBlueColor, child: Text("JD", style: boldTextStyle(size: 16, color: Colors.white))),
                    ),
                    buildDivider(),
                    ListTile(
                      title: Text("Edit photo", style: TextStyle(color: CSDarkBlueColor)),
                      onTap: () => showBottomSheetForUpdatePhoto(context),
                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    )
                  ],
                ).paddingOnly(top: 15),
                buildDivider(isFull: true),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildListTileForSetting(title: "Email", subTitle: "skg1498@gmail.com"),
                    
                  
                  ],
                ).paddingOnly(top: 15),
                buildDivider(isFull: true),
               
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildListTileForSetting(
                      title: "Clear search history",
                      onTap: () {
                        toasty(context, "Recent search history cleared");
                      },
                    ),
                  ],
                ).paddingOnly(top: 15),
                buildListTileForSetting(
                  title: "Sign out of this Cloudbox",
                  color: Colors.red.shade800,
                  onTap: () async {
                    bool isSignOut = await (buildCommonDialog(
                      context,
                      posBtn: "Sign out",
                      content: "Are you sure you want to sign out from your $CSAppName account ?",
                    ));
                    if (isSignOut) {
                      finish(context);
                      CSStartingScreen().launch(context);
                    }
                    setState(() {});
                  },
                ),
                buildDivider(isFull: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
