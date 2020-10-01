import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hse_phsycul/HexColor.dart';
import 'package:hse_phsycul/constants.dart';
import 'package:hse_phsycul/pages/shcedule_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';

class MyScheduleClass extends StatefulWidget {
  @override
  _MyScheduleClassState createState() => _MyScheduleClassState();
}

class _MyScheduleClassState extends State<MyScheduleClass> {
  String currentClass;
  DataSource events;
  final DateTime now = DateTime.now();
  final AsyncMemoizer _memoizer = AsyncMemoizer(); // asyncInit run only once

  Future<bool> asyncInit() async {
    await _memoizer.runOnce(() async {
      await getCurrentClass();
      events = DataSource(getAppointments());
      print('Loaded current list and got appointments');
    });
    return true;
  }

  Future<void> getCurrentClass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('currentClass');
    setState(() => currentClass = value ?? onlineClasses[0]);
  }

  Future<void> saveCurrentClass(newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentClass', newValue);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, 'HomePage');
        return;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: HexColor.fromHex('#713045'),
          child: SvgPicture.asset('assets/geo.svg', color: HexColor.fromHex('#f5f7f9'), width: 25),
          onPressed: () => showModalBottomSheet(context: context, builder: (context) => onlineClassBottomSheet()),
        ),
        body: SafeArea(
          child: FutureBuilder<bool>(
            future: asyncInit(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == false) return Center(child: CircularProgressIndicator());
              return Stack(
                children: [
                  SfCalendar(
                    view: CalendarView.month,
                    firstDayOfWeek: 1,
                    dataSource: events,
                    initialDisplayDate: DateTime(now.year, now.month, now.day, 8, 0),
                    initialSelectedDate: DateTime.now(),
                    // if using CalendarView.week
                    // timeSlotViewSettings: TimeSlotViewSettings(
                    //   timeFormat: 'HH:mm',
                    //   timeTextStyle: TextStyle(fontSize: 13, color: Colors.black),
                    //   startHour: 8,
                    //   endHour: 21,
                    //   timeInterval: Duration(minutes: 30),
                    //   timeIntervalHeight: 50,
                    // ),
                    selectionDecoration: BoxDecoration(
                      border: Border.all(color: HexColor.fromHex('#713045'), width: 2),
                    ),
                    appointmentTimeTextFormat: 'HH:mm',
                    monthViewSettings: MonthViewSettings(
                      showAgenda: true,
                      numberOfWeeksInView: 3,
                      agendaViewHeight: MediaQuery.of(context).size.height / 1.7,
                    ),
                    todayHighlightColor: myDarkColor,
                    headerStyle: CalendarHeaderStyle(textAlign: TextAlign.end),
                    onTap: (CalendarTapDetails details) => openSubjectInfo(details),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: myDarkColor),
                    onPressed: () => Navigator.pushNamed(context, 'HomePage'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void openSubjectInfo(CalendarTapDetails details) {
    List<dynamic> res = details.appointments;
    if (res != null && res.length == 1) {
      String notesEncoded = res[0].notes;
      var notesDecoded = json.decode(notesEncoded);
      showModalBottomSheet(context: context, builder: (context) => subjectBottomSheet(notesDecoded));
    }
  }

  Widget subjectBottomSheet(notesDecoded) {
    print(notesDecoded);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                notesDecoded['type'],
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              subtitle: Text(notesDecoded['date']),
            ),
            ListTile(
              leading: Icon(Icons.person_pin, color: myDarkColor, size: 30),
              title: Text(notesDecoded['tutor'], style: TextStyle(fontSize: 18)),
            ),
            ListTile(
              leading: Icon(Icons.schedule, color: myDarkColor),
              title: Text(
                '${notesDecoded['timeStart']} - ${notesDecoded['timeEnd']}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              leading: SvgPicture.asset('assets/building.svg', width: 22),
              title: Text(currentClass),
            ),
          ],
        ),
      ),
    );
  }

  List<Appointment> getAppointments() {
    RecurrenceProperties recurrence = new RecurrenceProperties();
    recurrence.recurrenceType = RecurrenceType.daily;
    recurrence.recurrenceRange = RecurrenceRange.count;
    recurrence.interval = 7;
    recurrence.recurrenceCount = 30;

    if (currentClass == null) return [];
    List<Appointment> result = List.generate(scheduleInfo[currentClass].length, (index) {
      int weekday = scheduleInfo[currentClass][index]['weekday'];
      int weekdayDiff = weekday - now.weekday - 7; // current weekday 1 week ago
      var date = DateFormat("dd.MM.yyyy").format(now.add(Duration(days: weekdayDiff)));
      var timeStart = scheduleInfo[currentClass][index]['timeStart'];
      var timeEnd = scheduleInfo[currentClass][index]['timeEnd'];
      var type = scheduleInfo[currentClass][index]['type'];
      var tutor = scheduleInfo[currentClass][index]['tutor'];
      DateTime timeStartDT = DateFormat("dd.MM.yyyy HH:mm").parse('$date $timeStart');
      DateTime timeEndDT = DateFormat("dd.MM.yyyy HH:mm").parse('$date $timeEnd');
      String notesEnc = json.encode({
        'date': date,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
        'type': type,
        'tutor': tutor,
      });

      return Appointment(
        color: myDarkColor,
        startTime: timeStartDT,
        endTime: timeEndDT,
        subject: type,
        notes: notesEnc,
        recurrenceRule: SfCalendar.generateRRule(recurrence, timeStartDT, timeEndDT),
      );
    });
    return result;
  }

  Widget onlineClassBottomSheet() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Online class:',
              style: TextStyle(color: myDarkColor, fontSize: 22, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20),
            DropdownButton(
              underline: Container(),
              isExpanded: true,
              value: currentClass,
              items: onlineClasses
                  .map((String _class) => DropdownMenuItem(
                        value: _class,
                        child: Text(_class, overflow: TextOverflow.ellipsis, maxLines: 3),
                        onTap: () async {
                          if (_class != currentClass) {
                            await saveCurrentClass(_class);
                            Navigator.pushNamed(context, 'SchedulePage');
                          } else
                            Navigator.pop(context);
                        },
                      ))
                  .toList(),
              onChanged: (value) => null, // because we reopen this page
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
