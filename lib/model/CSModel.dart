import 'package:cloud_storage/component/CSCommonFileComponents.dart';
import 'package:cloud_storage/screens/CSDashboardScreen.dart';
import 'package:cloud_storage/screens/CSOfflineScreen.dart';
import 'package:cloud_storage/screens/CSPhotosScreen.dart';
import 'package:cloud_storage/screens/CSSettingScreen.dart';
import 'package:cloud_storage/screens/CSUpgradeAccountScreen.dart';
import 'package:cloud_storage/utils/CSConstants.dart';
import 'package:cloud_storage/utils/CSImages.dart';
import 'package:flutter/material.dart';


class CSDataModel {
  String fileUrl;
  String? fileName;
  bool? isFileSelect;
  bool isDownload;
  bool isStared;
  bool isFolder;
  bool isShared;

  CSDataModel({this.fileUrl = CSDefaultImg, this.fileName, this.isFileSelect = false, this.isDownload = false, this.isShared = false, this.isStared = false, this.isFolder = false});
}

List<CSDataModel> getCloudboxData() {
  List<CSDataModel> _dataModel = [];
  _dataModel.add(CSDataModel(fileName: "Books", fileUrl: CSBookImg, isDownload: true));
  _dataModel.add(CSDataModel(fileName: "Nog says bow bow", fileUrl: CSDogGIFImg, isDownload: true));
  _dataModel.add(CSDataModel(fileName: "CloudBox file", fileUrl: CSCloudboxLogo, isStared: true));
  _dataModel.add(CSDataModel(fileName: "John", fileUrl: CSFolderIcon, isFolder: true));

  return _dataModel;
}

class CSDrawerModel {
  String? title;
  IconData? icon;
  Widget? goto;
  bool isSelected;

  CSDrawerModel({this.title, this.icon, this.goto, this.isSelected = false});
}

List<CSDrawerModel> getCSDrawer() {
  List<CSDrawerModel> _drawerModel = [];
  _drawerModel.add(CSDrawerModel(title: "Home", icon: Icons.home, goto: CSDashboardScreen()));
  _drawerModel.add(CSDrawerModel(title: "Files", icon: Icons.folder, goto: CSCommonFileComponents(appBarTitle: CSAppName)));
  _drawerModel.add(CSDrawerModel(title: "Photos", icon: Icons.photo, goto: CSPhotosScreen()));
  _drawerModel.add(CSDrawerModel(title: "Offline", icon: Icons.offline_bolt, goto: CSOfflineScreen()));
  //_drawerModel.add(CSDrawerModel(title: "Notification", icon: Icons.notifications,goto: SizedBox()));
  _drawerModel.add(CSDrawerModel(title: "Upgrade Account", icon: Icons.upgrade, goto: CSUpgradeAccountScreen()));
  _drawerModel.add(CSDrawerModel(title: "Setting", icon: Icons.settings, goto: CSSettingScreen()));

  return _drawerModel;
}
