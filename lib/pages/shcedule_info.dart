// type
String _therapeutic = "therapeutic";
String _therapeuticLong = "therapeuticLong";
String _selfDefense = "selfDefense";
String _theraStretching = "theraStretching";
String _theraStretchingLong = "theraStretchingLong";
String _yoga = "yoga";
String _funcTraining = "funcTraining";

// _ugriumovaNEN = "Natalia Ugriumova" ...
final List<String> onlineClasses = <String>["address_1", "address_2"];

Map<String, List<Map<String, dynamic>>> scheduleInfo = {
  // Kanta
  "address_1": [
    // Monday
    {"weekday": 1, "timeStart": "08:00", "timeEnd": "09:20", "tutor": "Natalia Ugriumova", "type": _therapeutic},
    {"weekday": 1, "timeStart": "09:30", "timeEnd": "10:50", "tutor": "Nadezhda  Guscina / Natalia Ugriumova", "type": _yoga},
    {"weekday": 1, "timeStart": "11:10", "timeEnd": "12:30", "tutor": "Natalia Ugriumova / Nadezhda  Guscina", "type": _therapeutic},
    {"weekday": 1, "timeStart": "13:00", "timeEnd": "14:20", "tutor": "Nadezhda  Guscina / Natalia Ugriumova", "type": _funcTraining},
    {"weekday": 1, "timeStart": "14:40", "timeEnd": "16:00", "tutor": "Gennady Yakovlev / Nadezhda  Guscina", "type": _funcTraining},
    {"weekday": 1, "timeStart": "16:20", "timeEnd": "17:40", "tutor": "Nadezhda  Guscina / Gennady Yakovlev", "type": _funcTraining},
    {"weekday": 1, "timeStart": "18:10", "timeEnd": "19:30", "tutor": "Gennady Yakovlev", "type": _funcTraining},
    {"weekday": 1, "timeStart": "19:40", "timeEnd": "21:00", "tutor": "Gennady Yakovlev", "type": _funcTraining},
    // Tuesday
    {"weekday": 2, "timeStart": "08:00", "timeEnd": "09:20", "tutor": "Natalia Ugriumova", "type": _therapeutic},
    {"weekday": 2, "timeStart": "09:30", "timeEnd": "10:50", "tutor": "Natalia Ugriumova / Daria Belorukova", "type": _therapeutic},
    {"weekday": 2, "timeStart": "11:10", "timeEnd": "12:30", "tutor": "Daria Belorukova / Natalia Ugriumova", "type": _funcTraining},
    {"weekday": 2, "timeStart": "13:00", "timeEnd": "14:20", "tutor": "Nadezhda  Guscina / Daria Belorukova", "type": _funcTraining},
    {"weekday": 2, "timeStart": "14:40", "timeEnd": "16:00", "tutor": "Daria Belorukova / Nadezhda  Guscina", "type": _therapeuticLong},
    {"weekday": 2, "timeStart": "16:20", "timeEnd": "17:40", "tutor": "Nadezhda  Guscina / Gennady Yakovlev", "type": _yoga},
    {"weekday": 2, "timeStart": "18:10", "timeEnd": "19:30", "tutor": "Gennady Yakovlev / Nadezhda  Guscina", "type": _funcTraining},
    {"weekday": 2, "timeStart": "19:40", "timeEnd": "21:00", "tutor": "Nadezhda  Guscina / Gennady Yakovlev", "type": _funcTraining},
    // Wednesday
    {"weekday": 3, "timeStart": "08:00", "timeEnd": "09:20", "tutor": "Natalia Ugriumova", "type": _therapeutic},
    {"weekday": 3, "timeStart": "09:30", "timeEnd": "10:50", "tutor": "Natalia Ugriumova / Olesya Kostova", "type": _therapeutic},
    {"weekday": 3, "timeStart": "11:10", "timeEnd": "12:30", "tutor": "Olesya Kostova / Natalia Ugriumova", "type": _funcTraining},
    {"weekday": 3, "timeStart": "13:00", "timeEnd": "14:20", "tutor": "Samedov Dzhemil / Olesya Kostova", "type": _selfDefense},
    {"weekday": 3, "timeStart": "14:40", "timeEnd": "16:00", "tutor": "Olesya Kostova / Samedov Dzhemil", "type": _therapeutic},
    {"weekday": 3, "timeStart": "16:20", "timeEnd": "17:40", "tutor": "Samedov Dzhemil / Alexander Ugriumov", "type": _funcTraining},
    {"weekday": 3, "timeStart": "18:10", "timeEnd": "19:30", "tutor": "Alexander Ugriumov / Samedov Dzhemil", "type": _funcTraining},
    {"weekday": 3, "timeStart": "19:40", "timeEnd": "21:00", "tutor": "Samedov Dzhemil / Alexander Ugriumov", "type": _funcTraining},
    // Thursday_
    {"weekday": 4, "timeStart": "08:00", "timeEnd": "09:20", "tutor": "Alexander Ugriumov", "type": _funcTraining},
    {"weekday": 4, "timeStart": "09:30", "timeEnd": "10:50", "tutor": "Daria Belorukova / Alexander Ugriumov", "type": _theraStretching},
    {"weekday": 4, "timeStart": "11:10", "timeEnd": "12:30", "tutor": "Alexander Ugriumov / Daria Belorukova", "type": _funcTraining},
    {"weekday": 4, "timeStart": "13:00", "timeEnd": "14:20", "tutor": "Daria Belorukova / Olesya Kostova", "type": _therapeuticLong},
    {"weekday": 4, "timeStart": "14:40", "timeEnd": "16:00", "tutor": "Olesya Kostova / Daria Belorukova", "type": _therapeutic},
    {"weekday": 4, "timeStart": "16:20", "timeEnd": "17:40", "tutor": "Olesya Kostova / Fedor Kostov", "type": _theraStretching},
    {"weekday": 4, "timeStart": "18:10", "timeEnd": "19:30", "tutor": "Fedor Kostov / Olesya Kostova", "type": _funcTraining},
    // Friday
    {"weekday": 5, "timeStart": "08:00", "timeEnd": "09:20", "tutor": "Alexander Ugriumov", "type": _funcTraining},
    {"weekday": 5, "timeStart": "09:30", "timeEnd": "10:50", "tutor": "Olesya Kostova / Alexander Ugriumov", "type": _therapeutic},
    {"weekday": 5, "timeStart": "11:10", "timeEnd": "12:30", "tutor": "Alexander Ugriumov / Olesya Kostova", "type": _funcTraining},
    {"weekday": 5, "timeStart": "13:00", "timeEnd": "14:20", "tutor": "Olesya Kostova / Alexander Ugriumov", "type": _theraStretching},
    {"weekday": 5, "timeStart": "14:40", "timeEnd": "16:00", "tutor": "Ekaterina Avtomonova / Samedov Dzhemil", "type": _theraStretchingLong},
    {"weekday": 5, "timeStart": "16:20", "timeEnd": "17:40", "tutor": "Samedov Dzhemil / Ekaterina Avtomonova", "type": _selfDefense},
    {"weekday": 5, "timeStart": "18:10", "timeEnd": "19:30", "tutor": "Ekaterina Avtomonova / Samedov Dzhemil", "type": _theraStretchingLong},
    // Saturday
    {"weekday": 6, "timeStart": "09:30", "timeEnd": "10:50", "tutor": "Fedor Kostov", "type": _funcTraining},
    {"weekday": 6, "timeStart": "11:10", "timeEnd": "12:30", "tutor": "Daria Belorukova / Fedor Kostov", "type": _funcTraining},
    {"weekday": 6, "timeStart": "13:00", "timeEnd": "14:20", "tutor": "Fedor Kostov / Daria Belorukova", "type": _funcTraining},
    {"weekday": 6, "timeStart": "14:40", "timeEnd": "16:00", "tutor": "Daria Belorukova / Fedor Kostov", "type": _funcTraining},
    {"weekday": 6, "timeStart": "16:20", "timeEnd": "17:40", "tutor": "Fedor Kostov", "type": _funcTraining}
  ],
  // Griboedova
  "address_2": [
    // TODO: add Griboedova schedule
    // Monday
  ],
};
