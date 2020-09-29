import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hse_phsycul/HexColor.dart';
import 'package:hse_phsycul/constants.dart';
import 'package:hse_phsycul/pages/shcedule_info.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class MyScheduleClass extends StatefulWidget {
  @override
  _MyScheduleClassState createState() => _MyScheduleClassState();
}

class _MyScheduleClassState extends State<MyScheduleClass> {
  final List<String> onlineClasses = <String>['Kantemirovskaya, 3А, room 172', 'Kanala Griboedova Embankment, 123,  room 100'];
  String currentClass;
  DataSource events;
  final DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    currentClass = onlineClasses[0];
    events = DataSource(getAppointments());
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
          child: Stack(
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
      height: 240,
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: ListView(
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
        ],
      ),
    );
  }

  List<Appointment> getAppointments() {
    RecurrenceProperties recurrence = new RecurrenceProperties();
    recurrence.recurrenceType = RecurrenceType.daily;
    recurrence.recurrenceRange = RecurrenceRange.count;
    recurrence.interval = 7;
    recurrence.recurrenceCount = 30;
    List<Appointment> result = List.generate(scheduleKanta.length, (index) {
      int weekday = scheduleKanta[index]['weekday'];
      int weekdayDiff = weekday - now.weekday - 7; // current weekday 1 week ago
      var date = DateFormat("dd.MM.yyyy").format(now.add(Duration(days: weekdayDiff)));
      var timeStart = scheduleKanta[index]['timeStart'];
      var timeEnd = scheduleKanta[index]['timeEnd'];
      var type = scheduleKanta[index]['type'];
      var tutor = scheduleKanta[index]['tutor'];
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
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Online class:',
            style: TextStyle(color: myDarkColor, fontSize: 22, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 40),
          Expanded(
            child: DropdownButton(
              underline: Container(),
              isExpanded: true,
              value: currentClass,
              items: onlineClasses
                  .map((String _class) => DropdownMenuItem(
                        value: _class,
                        child: Text(_class, overflow: TextOverflow.ellipsis, maxLines: 3),
                        onTap: () => Navigator.pop(context),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => currentClass = value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
