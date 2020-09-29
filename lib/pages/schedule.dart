import 'package:flutter/material.dart';
import 'package:hse_phsycul/HexColor.dart';
import 'package:hse_phsycul/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class MyScheduleClass extends StatelessWidget {
  const MyScheduleClass({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, 'HomePage');
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Documents'),
          backgroundColor: myDarkColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: HexColor.fromHex('#f5f7f9')),
            onPressed: () => Navigator.pushNamed(context, 'HomePage'),
          ),
        ),
        body: SafeArea(
          child: ListView.builder(
            itemCount: scheduleDocuments.length,
            itemBuilder: (context, index) {
              String docTitle = scheduleDocuments[index]['title'];
              String docDate = DateFormat("dd.MM.yyyy HH:mm").format(scheduleDocuments[index]['date']);
              String docUrl = scheduleDocuments[index]['url'];

              return ListTile(
                leading: Icon(MdiIcons.fileDocumentOutline, color: myDarkColor, size: 30),
                title: Text(
                  docTitle,
                  maxLines: 3,
                  style: TextStyle(fontSize: 14, color: myDarkColor),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(docDate),
                //TODO: открывать таблички через syncfusion table
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyWebViewScaffold(docTitle, docUrl),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
