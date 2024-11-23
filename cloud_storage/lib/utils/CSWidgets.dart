import 'dart:io';
import 'dart:math';

import 'package:cloud_storage/main.dart';
import 'package:cloud_storage/model/CSModel.dart';
import 'package:cloud_storage/screens/CSSignInScreen.dart';
import 'package:cloud_storage/utils/CSColors.dart';
import 'package:cloud_storage/utils/CSImages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



// ignore: non_constant_identifier_names
AppBar CSCommonAppBar(BuildContext context, {String title = 'Enter AppName', bool isBack = true}) {
  return AppBar(
    title: Text(title, style: boldTextStyle()),
    leading: isBack
        ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              finish(context);
            },
          )
        : 0.height,
  );
}

InputDecoration buildInputDecoration(String labelText) {
  return InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    labelText: labelText,
    labelStyle: TextStyle(color: Colors.black),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Colors.black, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Colors.red, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Colors.red, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.5, color: CSGreyColor),
      borderRadius: BorderRadius.zero,
    ),
  );
}

Widget createBasicListTile({IconData? icon, required String text, Function? onTap}) {
  return ListTile(
    contentPadding: EdgeInsets.all(0),
    visualDensity: VisualDensity(horizontal: -4, vertical: -2),
    onTap: onTap as void Function()?,
    title: Text(text, style: TextStyle(fontSize: 16)),
    leading: Icon(icon, color: Colors.black, size: 22),
  );
}

Widget authButtonWidget(String btnTitle) {
  return Container(
    height: 50,
    padding: EdgeInsets.all(10),
    alignment: Alignment.center,
    decoration: boxDecorationRoundedWithShadow(5, backgroundColor: CSDarkBlueColor, spreadRadius: 1, blurRadius: 0, shadowColor: Colors.grey, offset: Offset(0, 1)),
    child: Text(
      btnTitle,
      style: boldTextStyle(color: Colors.white),
    ),
  );
}




Widget buildDivider({bool isFull = false}) {
  return Divider(color: Colors.grey).paddingLeft(isFull ? 0 : 16);
}

Future showBottomSheetForAddingData(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext ctx) {
      return Wrap(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.grey),
                ListTile(
                  leading: Icon(Icons.cloud_upload),
                  title: Text("Upload file"),
                  onTap: () => uploadFile(context),
                ),
                createBasicListTile(text: "Create new folder", icon: Icons.folder).onTap(() async {
                  var folderName = await buildCreateFolderDialog(context);
                  if (folderName != null) {
                    // Отправляем запрос на сервер
                    await createFolderOnServer(folderName, '');
                    getCloudboxList.add(CSDataModel(fileName: folderName, fileUrl: CSFolderIcon, isFolder: true));
                    finish(context);
                  }
                }),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<void> createFolderOnServer(String folderName, String path) async {
  final url = Uri.parse('http://localhost:8080/api/minio/create-folder');
  final response = await authenticatedRequest(
    url,
    'POST',
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': folderName, 'path': path}),
  );

  if (response.statusCode == 200) {
    print('Folder created successfully');
  } else {
    print('Failed to create folder: ${response.statusCode}');
  }
}




Future<void> uploadFile(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);
    String fileName = result.files.single.name;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:8080/files/upload'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
      ),
    );

    request.fields['currentPath'] = ''; // Укажите текущий путь, если нужно

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Токен не найден');
    }

    request.headers['Authorization'] = 'Bearer $token';

    var response = await request.send();

    if (response.statusCode == 200) {
      print('File uploaded successfully');
      // Генерируем случайное имя для файла
      String randomFileName = "uploadFileDoggi${Random().nextInt(10000)}";
      // Добавляем файл в getCloudboxList
      getCloudboxList.add(CSDataModel(fileName: randomFileName, fileUrl: CSFileImg, isFolder: true));
      // Обновляем интерфейс
    } else {
      print('File upload failed');
    }
  } else {
    // Пользователь отменил выбор файла
  }
}




Future buildRenameDialog(BuildContext context, TextEditingController controller) {
  bool isFileNameChange = false;
  String oldName = controller.text;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, state) {
          return AlertDialog(
            buttonPadding: EdgeInsets.all(8),
            contentPadding: EdgeInsets.fromLTRB(25, 16, 32, 8),
            insetPadding: EdgeInsets.all(16),
            title: Text("Rename file", style: boldTextStyle(size: 24)),
            content: Wrap(
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  ),
                  onChanged: (val) {
                    if (val == oldName) {
                      isFileNameChange = false;
                    } else {
                      isFileNameChange = true;
                    }
                    state(() {});
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Cancel", style: boldTextStyle(size: 16, color: Colors.blueGrey)),
                onPressed: () {
                  finish(context, controller);
                },
              ),
              TextButton(
                child: Text("Rename", style: boldTextStyle(size: 16, color: isFileNameChange ? CSDarkBlueColor : Colors.grey)),
                onPressed: () {
                  finish(context, controller);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

Future buildDeleteDialog(BuildContext context, CSDataModel dataModel) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        buttonPadding: EdgeInsets.all(8),
        contentPadding: EdgeInsets.fromLTRB(25, 16, 32, 8),
        insetPadding: EdgeInsets.all(16),
        title: Text(dataModel.fileName!, style: boldTextStyle(size: 24)),
        content: dataModel.isFolder ? Text("Are you sure you want to delete this folder ?") : Text("Are you sure you want to delete this item from your Cloudbox?"),
        actions: [
          TextButton(
            child: Text("Cancel", style: boldTextStyle(size: 16, color: Colors.grey)),
            onPressed: () {
              finish(context, false);
            },
          ),
          TextButton(
            child: Text("Delete", style: boldTextStyle(size: 16, color: CSDarkBlueColor)),
            onPressed: () {
              finish(context, true);
            },
          ),
        ],
      );
    },
  );
}

Future buildCommonDialog(BuildContext context, {String? title, String? content, String posBtn = "OK", String negBtn = "Cancel"}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        buttonPadding: EdgeInsets.all(8),
        contentPadding: EdgeInsets.fromLTRB(25, 16, 32, 8),
        insetPadding: EdgeInsets.all(16),
        title: title.isEmptyOrNull ? null : Text(title!, style: boldTextStyle(size: 24)),
        content: Text(content!),
        actions: [
          TextButton(
            child: Text(negBtn, style: boldTextStyle(size: 16, color: Colors.grey)),
            onPressed: () {
              finish(context, false);
            },
          ),
          TextButton(
            child: Text(posBtn, style: boldTextStyle(size: 16, color: CSDarkBlueColor)),
            onPressed: () {
              finish(context, true);
            },
          ),
        ],
      );
    },
  );
}

Future buildDeleteSelectedFileDialog(BuildContext context, String title) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        buttonPadding: EdgeInsets.all(8),
        contentPadding: EdgeInsets.fromLTRB(25, 16, 32, 8),
        insetPadding: EdgeInsets.all(16),
        title: Text(title, style: boldTextStyle(size: 24)),
        content: Text("Are you sure you want to delete these item from your Cloudbox?"),
        actions: [
          TextButton(
            child: Text("Cancel", style: boldTextStyle(size: 16, color: Colors.grey)),
            onPressed: () {
              finish(context, false);
            },
          ),
          TextButton(
            child: Text("Delete", style: boldTextStyle(size: 16, color: CSDarkBlueColor)),
            onPressed: () {
              finish(context, true);
            },
          ),
        ],
      );
    },
  );
}

Future showBottomSheetForUpdatePhoto(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext ctx) {
      return Wrap(children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update account photo",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ).paddingBottom(10),
              createBasicListTile(text: "Choose from Cloudbox", icon: Icons.camera_alt),
              createBasicListTile(text: "Choose from gallery", icon: Icons.my_library_books_outlined).onTap(() {
                ImagePicker().pickImage(source: ImageSource.gallery);
              }),
              createBasicListTile(text: "Use Camera", icon: Icons.photo_album_rounded).onTap(() {
                ImagePicker().pickImage(source: ImageSource.camera);
              }),
            ],
          ).paddingAll(10),
        ),
      ]);
    },
  );
}

Future buildCreateFolderDialog(BuildContext context) {
  bool isBlank = false;
  TextEditingController controller = TextEditingController();
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, state) {
          return AlertDialog(
            buttonPadding: EdgeInsets.all(8),
            insetPadding: EdgeInsets.all(16),
            title: Text("Create new folder", style: boldTextStyle(size: 20)),
            content: Row(
              children: [
                Image.asset(CSFolderIcon, height: 30, width: 30),
                10.width,
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      state(() {});
                      if (val.isEmpty) {
                        isBlank = false;
                      } else {
                        isBlank = true;
                      }
                    },
                    controller: controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      hintText: "Untitled folder",
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                child: Text("Cancel", style: boldTextStyle(size: 16, color: Colors.blueGrey)),
                onPressed: () {
                  finish(context);
                },
              ),
              TextButton(
                child: Text("Create", style: boldTextStyle(size: 16, color: isBlank ? CSDarkBlueColor : Colors.grey)),
                onPressed: () {
                  if (isBlank) finish(context, controller.text);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

Widget buildListTileForSetting({required String title, String subTitle = "", Widget? trailing, Widget? leading, Color? color, Function? onTap, bool isEnable = true}) {
  return ListTile(
    enabled: isEnable,
    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    title: Text(title, style: TextStyle(color: color.toString().isEmpty ? Colors.black : color)),
    subtitle: subTitle.isEmpty ? null : Text(subTitle),
    trailing: trailing,
    leading: leading,
    onTap: onTap as void Function()?,
  );
}
