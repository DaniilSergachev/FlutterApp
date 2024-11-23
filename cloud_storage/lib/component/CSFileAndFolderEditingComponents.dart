import 'package:cloud_storage/component/CSCopyAndMoveComponents.dart';
import 'package:cloud_storage/main.dart';
import 'package:cloud_storage/model/CSModel.dart';
import 'package:cloud_storage/utils/CSConstants.dart';
import 'package:cloud_storage/utils/CSImages.dart';
import 'package:cloud_storage/utils/CSWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

Future showBottomSheetForFileAndFolderEditingOption(BuildContext context, CSDataModel dataModel) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => Container(
      padding: EdgeInsets.only(top: 20),
      child: StatefulBuilder(
        builder: (BuildContext ctx, StateSetter state) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            expand: false,
            maxChildSize: 1.0,
            builder: (_, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    children: [
                      lisTileForFileEditingOption(
                        title: dataModel.fileName!,
                        leading: dataModel.isFolder ? Image.asset(CSFolderIcon, width: 40, height: 40) : Image.asset(CSFileImg, width: 40, height: 40),
                        subTitle: dataModel.isFolder ? CSAppName : "date and size of the file",
                      ),
                      
                      dataModel.isStared
                          ? lisTileForFileEditingOption(title: "Unstar", leading: blackIcon(MaterialCommunityIcons.star_off)).onTap(() {
                              state(() {
                                dataModel.isStared = false;
                                finish(context);
                              });
                            })
                          : lisTileForFileEditingOption(title: "Star", leading: blackIcon(Icons.star_border)).onTap(() {
                              state(() {
                                dataModel.isStared = true;
                                finish(context);
                              });
                            }),
                      lisTileForFileEditingOption(title: "Rename", leading: blackIcon(Icons.edit)).onTap(() async {
                        TextEditingController controller = TextEditingController();
                        controller.text = dataModel.fileName!;
                        controller = await (buildRenameDialog(context, controller));
                        if (controller.text != dataModel.fileName) {
                          dataModel.fileName = controller.text;
                          finish(context);
                        }
                      }),
                      lisTileForFileEditingOption(
                        title: "Copy",
                        leading: blackIcon(Icons.copy),
                      ).onTap(
                        () {
                          finish(context);
                          CSCopyAndMoveComponents(
                            appBarTitle: "Copy ${dataModel.fileName} to",
                            listOfData: getCloudboxList,
                          ).launch(context);
                        },
                      ),
              
                      dataModel.isShared ? 0.height : buildDivider(isFull: true),
                      dataModel.isShared
                          ? 0.height
                          : lisTileForFileEditingOption(
                              title: "Delete",
                              leading: Icon(Icons.delete, color: Colors.red),
                              color: Colors.red,
                            ).onTap(
                              () async {
                                //success
                                bool isFileDeleted = await (buildDeleteDialog(context, dataModel));
                                if (isFileDeleted) {
                                  getCloudboxList.removeWhere(
                                    (element) {
                                      return element.fileName == dataModel.fileName;
                                    },
                                  );
                                }
                                finish(context);
                              },
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}

Widget lisTileForFileEditingOption({required String title, String subTitle = "", Widget? trailing, Color? color, Widget? leading}) {
  return ListTile(
    contentPadding: EdgeInsets.all(0),
    visualDensity: VisualDensity(horizontal: -3, vertical: -4),
    title: Text(title, style: TextStyle(color: color.toString().isEmpty ? Colors.black : color)),
    subtitle: subTitle.isEmpty ? null : Text(subTitle),
    trailing: trailing,
    leading: leading,
  );
}

Widget blackIcon(IconData icon) {
  return Icon(
    icon,
    color: Colors.black,
  );
}