import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'HexColor.dart';
import 'package:flutter/material.dart';

var myDarkColor = HexColor.fromHex('#2d4059');
const String createQRCodeUrl = 'https://script.google.com/macros/s/AKfycbwhHOhwMOCUAtbnlH6fTbGH7wgs1cA9IaZmYj3Ai5QYRnhHDYA/exec';
const String trackAttendanceUrl = 'https://script.google.com/macros/s/AKfycbyQG8362gVw2DrdiLyqbDPm6dISB-2u7G-SbQaFm9Paby3vamM/exec';
const String homeTrainingsUrl = 'https://vk.com/videos-101805646';

var scheduleDocuments = <Map<String, dynamic>>[
  {
    'title': 'List_of_tutors_of_the_Department_of_Physical_Training_responsible_for_educational_programs.docx',
    'date': DateTime(2020, 09, 26, 16, 23),
    'url': 'https://vk.com/doc-101805646_568224334',
  },
  {
    'title': 'Schedule PE online.xlsx',
    'date': DateTime(2020, 09, 26, 16, 23),
    'url': 'https://vk.com/doc-101805646_568224312',
  },
  {
    'title': 'Список ответственных за ОП_20-21.docx',
    'date': DateTime(2020, 09, 24, 11, 56),
    'url': 'https://vk.com/doc-101805646_567906961',
  },
  {
    'title': 'Расписание ФК 2020-2021 _трансляции.xlsx',
    'date': DateTime(2020, 09, 23, 11, 57),
    'url': 'https://vk.com/doc-101805646_567763240',
  },
];

List<Map<String, String>> eduPrograms = [
  {'value': 'ВВЕД', 'name': 'Востоковедение'},
  {'value': 'ДИЗН', 'name': 'Дизайн'},
  {'value': 'ИСТР', 'name': 'История'},
  {'value': 'ЛУЦП', 'name': 'Логистика и УЦП'},
  {'value': 'МБМН', 'name': 'Междунар. бизнес и менеджмент'},
  {'value': 'МНДЖ', 'name': 'Менеджмент'},
  {'value': 'ПИМП', 'name': 'Политология и мир. политика'},
  {'value': 'ПМИН', 'name': 'Прикл. математика и информатика'},
  {'value': 'ССИН', 'name': 'Социология и соц. информатика'},
  {'value': 'УАГС', 'name': 'Упр. и аналитика в гос. секторе'},
  {'value': 'ФИЗ', 'name': 'Физика'},
  {'value': 'ФИЛЛ', 'name': 'Филология'},
  {'value': 'ФИНН', 'name': 'Финансы'},
  {'value': 'ЭКОН', 'name': 'Экономика'},
  {'value': 'ЮРПР', 'name': 'Юриспруденция'},
  {'value': 'ЮРПРо', 'name': 'Юриспруденция (о/з)'},
];

class MyWebViewScaffold extends StatelessWidget {
  final String appBarTitle;
  final String url;
  const MyWebViewScaffold(this.appBarTitle, this.url);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      initialChild: Center(child: CircularProgressIndicator()),
      userAgent: "random",
      withZoom: true,
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: myDarkColor,
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
