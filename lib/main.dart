import 'package:drawing_animation/drawing_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hse_phsycul/constants.dart';
import 'package:hse_phsycul/pages/faq.dart';
import 'package:hse_phsycul/pages/qr_code_beta_page.dart';
import 'package:hse_phsycul/pages/qr_code_page.dart';
import 'package:hse_phsycul/pages/schedule.dart';
import 'package:hse_phsycul/pages/settings.dart';
import 'package:hse_phsycul/themes.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'HexColor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:theme_provider/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';

String localePath = 'assets/locale';

void main() {
  runApp(EasyLocalization(
    supportedLocales: [Locale('ru', 'RU'), Locale('en', 'US')],
    path: localePath,
    fallbackLocale: Locale('en', 'US'), // locale when the system locale is not supported
    saveLocale: true,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: myThemes,
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            debugShowCheckedModeBanner: false,
            home: MyHomePage(),
            routes: {
              'HomePage': (context) => MyHomePage(),
              'QRCodePage': (context) => QRCodePage(),
              'QRCodeBetaPage': (context) => QRCodeBetaPage(),
              'SchedulePage': (context) => MyScheduleClass(),
              'FaqPage': (context) => FaqMarkDown(),
              'SettingsPage': (context) => SettingsPage(),
            },
            localizationsDelegates: context.localizationDelegates, //+ [SfGlobalLocalizations.delegate],
            locale: context.locale,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(),
        body: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              MySliverAppBar(_scaffoldKey),
              SliverFillRemaining(
                child: Container(
                  height: MediaQuery.of(context).size.height - 80,
                  child: IconButton(
                    icon: Icon(Icons.adb),
                    onPressed: () => print(context.localizationDelegates),
                  ),
                ),
                hasScrollBody: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySliverAppBar extends StatefulWidget {
  const MySliverAppBar(this._scaffoldKey);
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  _MySliverAppBarState createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  int _randomValue = 1 + Random().nextInt(7);
  bool run = true;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 160,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color, size: 30),
        onPressed: () => widget._scaffoldKey.currentState.openDrawer(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        title: Text(
          tr("main_appbar_title"),
          style: TextStyle(color: Theme.of(context).textTheme.headline6.color),
        ),
        background: AnimatedCrossFade(
          firstChild: AnimatedDrawing.svg(
            'assets/images/sport_$_randomValue.svg',
            run: this.run,
            onFinish: () => setState(() => this.run = false),
            animationOrder: PathOrders.topToBottom,
            lineAnimation: LineAnimation.allAtOnce,
            duration: new Duration(seconds: 1, milliseconds: 300),
          ),
          secondChild: SvgPicture.asset('assets/images/sport_$_randomValue.svg', fit: BoxFit.fitHeight),
          crossFadeState: this.run ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(seconds: 1, milliseconds: 500),
        ),
        // background: SvgPicture.asset('assets/images/sport_$_randomValue.svg', fit: BoxFit.fitHeight),
      ),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: myDarkColor),
      accountName: Text('Adilet', style: TextStyle(fontSize: 20), maxLines: 1, overflow: TextOverflow.ellipsis),
      accountEmail: Text('amabiraev@edu.hse.ru'),
      currentAccountPicture: CircleAvatar(
        child: Icon(Icons.person, color: myDarkColor, size: 35),
        backgroundColor: HexColor.fromHex('#f8f8f8'),
      ),
    );

    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: Text('qr_code'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: Icon(MdiIcons.qrcodeScan, size: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.pushNamed(context, 'QRCodePage'),
        ),
        ListTile(
          title: Text('QR_code_beta'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: Icon(MdiIcons.qrcodeScan, size: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.pushNamed(context, 'QRCodeBetaPage'),
        ),
        ListTile(
          title: Text('journal'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/icons/calendar_check.svg', width: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => MyWebViewScaffold('attandance_tracking'.tr(), trackAttendanceUrl),
            ),
          ),
        ),
        ListTile(
          title: Text('schedule'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/icons/calendar_days.svg', width: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.pushNamed(context, 'SchedulePage'),
        ),
        ListTile(
          title: Text('train_at_home'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/icons/home.svg', width: 24, color: Theme.of(context).iconTheme.color),
          onTap: () async => await launch(homeTrainingsUrl),
        ),
        ListTile(
          title: Text('hike'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: Icon(MdiIcons.hiking, size: 24, color: Theme.of(context).iconTheme.color),
          onTap: () {
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'not_implemented'.tr());
          },
        ),
        Divider(color: Theme.of(context).textTheme.caption.color),
        ListTile(
          title: Text('settings'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/icons/settings.svg', width: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.pushNamed(context, 'SettingsPage'),
        ),
        ListTile(
          title: Text('faq'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/icons/faq.svg', width: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.pushNamed(context, 'FaqPage'),
        ),
        ListTile(
          leading: SvgPicture.asset(
            ThemeProvider.themeOf(context).id != 'dark' ? 'assets/icons/brightness_low.svg' : 'assets/icons/brightness_high.svg',
            width: 28,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text('dark_mode'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          trailing: Switch(
            value: ThemeProvider.themeOf(context).id == 'dark',
            onChanged: (bool value) => ThemeProvider.controllerOf(context).nextTheme(),
          ),
        ),
      ],
    );

    return Container(
      width: 260,
      child: Drawer(
        child: drawerItems,
      ),
    );
  }
}
