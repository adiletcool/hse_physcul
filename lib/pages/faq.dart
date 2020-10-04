import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hse_phsycul/HexColor.dart';
import 'package:hse_phsycul/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

const String _markDownSrc = '''
# __Ответы на часто задаваемые вопросы.__
 - ### ОПОЗДАВШИЕ СТУДЕНТЫ НА ЗАНЯТИЯ НЕ ДОПУСКАЮТСЯ !!!
1. Спортивная форма и сменная обувь обязательны на любом занятии по физической культуре.
2. На одной базе (адресе) вы можете посетить 1 занятие, которое пойдет в зачет (кроме лекций и шахмат).То есть, если вы сходите в зал, а потом на шахматы, в зачет пойдут оба занятия, но если вы два раза сходите в зал – только одно.
3. Если вы на 2-4 курсе, и в качестве допуска к зачету хотите предоставить договор из фитнес-клуба (танцевальной секции, плавания и т.д.) – он должен покрывать 1 и 2 модуль целиком (+- 2 недели). Для студентов МСГ - это должна быть справка о том, что вы действительно посещаете спортивные занятия, а не просто проживаете в студ.городке.
4. Студенты специальных медицинских групп, посещающие занятия ЛФК также могут предоставить абонент из поликлиники или фитнес-клуба (если посещаются коррекционные занятия). В таком случае, в справке или договоре важно отобразить СРОКИ действия абонемента.
5. Договоров может быть несколько (например, за каждый месяц или за полгода). Если вы потеряли свой договор, обратитесь в ваш фитнес клуб для предоставления справки о том, что вы там занимаетесь, с указанием сроков действия вашего договора, печатью и подписью.
6. За каждую ОП отвечает конкретный преподаватель. Если у вас возникла проблема, обратитесь к своему преподавателю. Список [здесь](https://spb.hse.ru/mfk/fvspb/plan).
7. Все нормативы для сдачи зачета [здесь](https://spb.hse.ru/mfk/fvspb/plan).
8. Занятия ЛФК могут посещать только студенты специальной медицинской группы.
9. Студенты специальных медицинских групп могут посещать ТОЛЬКО ЗАНЯТИЯ ЛФК. Если у вас возникли вопросы по поводу ЛФК или мобильности, пишите Овчинниковой С.В.
10. Посещать спортивные секции (волейбол, баскетбол, мини-футбол и т. д) могут все желающие студенты, независимо от уровня физической подготовки (кроме ЛФК).
11. Походы выходного дня обычно длятся 2-3 часа с момента встречи с преподавателями (зависит от погодных условий).
12. Если вы записались в поход выходного дня и не можете пойти – напишите об этом в соответствующем обсуждении.
13. QR-code для электронного журнала можно сделать на сайте (ссылка на [сайт]($createQRCodeUrl))
14. Ваш прошлогодний код может не работать, поэтому сделайте новый.
15. Если с новым QR-code у преподавателя не отображаются ваши ФИО, значит вы допустили какую-то ошибку в оформлении (например, лишний пробел) – надо переделать.
16. Если вы студент подготовительной группы здоровья – договор из фитнес-клуба служит вам зачетом (то есть с этим договором вы приходите на зачет и не сдаете нормативы).
17. Если в электронном журнале напротив вашей фамилии стоит количество часов,необходимое для автомата - на зачет приходить не нужно. Если вы оказались в списке с ошибками и у вас в нем автомат - приходить на зачет ОБЯЗАТЕЛЬНО. Если с вашей фамилией в журнале несколько строчек, и суммарно набирается автомат, приходить на зачет также НУЖНО.
18. Для аттестации по ФК в день зачета необходимо выполнить все контрольные упражнения на оценку «зачтено».
19. Последний день занятий по ФК во втором модуле – 22 декабря, в четвертом модуле – 16 июня.
20. Во время сессий и праздников занятий по ФК нет!
''';

class FaqMarkDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _onTapLink(href) async {
      if (await canLaunch(href)) {
        launch(href);
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong address: $href'),
          ),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('faq'.tr()),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: HexColor.fromHex('#f5f7f9')),
              onPressed: () => Navigator.pushNamed(context, 'HomePage'),
            ),
          ),
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabPageSelector(),
                Expanded(
                  child: TabBarView(
                    children: [
                      Markdown(
                        data: _markDownSrc,
                        onTapLink: _onTapLink,
                        selectable: true,
                      ),
                      ListView.builder(
                        itemCount: scheduleDocuments.length,
                        itemBuilder: (context, index) {
                          String docTitle = scheduleDocuments[index]['title'];
                          String docDate = DateFormat("dd.MM.yyyy HH:mm").format(scheduleDocuments[index]['date']);
                          String docUrl = scheduleDocuments[index]['url'];

                          return ListTile(
                            leading: Icon(MdiIcons.fileDocumentOutline, color: Theme.of(context).iconTheme.color, size: 30),
                            title: Text(
                              docTitle,
                              maxLines: 3,
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(docDate),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => MyWebViewScaffold(docTitle, docUrl),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
Markdown(
                  data: _markDownSrc,
                  onTapLink: _onTapLink,
                  selectable: true,
                ),

ListView.builder(
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
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => MyWebViewScaffold(docTitle, docUrl),
                        ),
                      ),
                    );
                  },
                ), */
