import 'package:cloud_storage/component/CSCommonFileComponents.dart';
import 'package:cloud_storage/screens/CSDashboardScreen.dart';
import 'package:cloud_storage/screens/CSSettingScreen.dart';
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
  _dataModel.add(CSDataModel(fileName: "John", fileUrl: CSFolderIcon, isFolder: true));
  _dataModel.add(CSDataModel(fileName: "Anime", fileUrl: CSFolderIcon, isFolder: true));
  _dataModel.add(CSDataModel(fileName: "IT", fileUrl: CSFileImg, isFolder: true));
  _dataModel.add(CSDataModel(fileName: "College", fileUrl: CSFolderIcon, isFolder: true));
  _dataModel.add(CSDataModel(fileName: "House", fileUrl: CSFolderIcon, isFolder: true));
  _dataModel.add(CSDataModel(fileName: "HomeWork", fileUrl: CSFileImg, isFolder: true));
  _dataModel.add(CSDataModel(fileName: "52", fileUrl: CSCloudboxLogo, isFolder: true));
  _dataModel.add(CSDataModel(fileName: "Dimka", fileUrl: CSFileImg, isFolder: true));
  _dataModel.add(CSDataModel(fileName: "Egorka", fileUrl: CSFileImg, isFolder: true));





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
 // _drawerModel.add(CSDrawerModel(title: "Photos", icon: Icons.photo, goto: CSPhotosScreen()));
  //_drawerModel.add(CSDrawerModel(title: "Notification", icon: Icons.notifications,goto: SizedBox()));
  _drawerModel.add(CSDrawerModel(title: "Settings", icon: Icons.settings, goto: CSSettingScreen()));

  return _drawerModel;
}
