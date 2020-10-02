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
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'HexColor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            localizationsDelegates: [GlobalMaterialLocalizations.delegate, SfGlobalLocalizations.delegate],
            supportedLocales: [const Locale('ru')],
            locale: const Locale('ru'),
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
                child: Container(height: MediaQuery.of(context).size.height - 80),
                hasScrollBody: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar(this._scaffoldKey);
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    int _randomValue = 1 + Random().nextInt(7);

    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 160,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color, size: 30),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        title: Text('HSE PE', style: TextStyle(color: Theme.of(context).textTheme.headline6.color)),
        background: SvgPicture.asset('assets/sport_$_randomValue.svg', fit: BoxFit.fitHeight),
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
          title: Text('QR-code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: Icon(MdiIcons.qrcodeScan, size: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.pushNamed(context, 'QRCodePage'),
        ),
        ListTile(
          title: Text('QR-code Beta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: Icon(MdiIcons.qrcodeScan, size: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.pushNamed(context, 'QRCodeBetaPage'),
        ),
        ListTile(
          title: Text('Journal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/calendar_check.svg', width: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => MyWebViewScaffold('Attendance tracking', trackAttendanceUrl),
            ),
          ),
        ),
        ListTile(
          title: Text('Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/calendar_days.svg', width: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.pushNamed(context, 'SchedulePage'),
        ),
        ListTile(
          title: Text('Train at home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/home.svg', width: 24, color: Theme.of(context).iconTheme.color),
          onTap: () async => await launch(homeTrainingsUrl),
        ),
        ListTile(
          title: Text('Hike', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: Icon(MdiIcons.hiking, size: 24, color: Theme.of(context).iconTheme.color),
          onTap: () {
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Not implemented yet');
          },
        ),
        Divider(color: Theme.of(context).textTheme.caption.color),
        ListTile(
          title: Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/settings.svg', width: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.pushNamed(context, 'SettingsPage'),
        ),
        ListTile(
          title: Text('FAQ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/faq.svg', width: 24, color: Theme.of(context).iconTheme.color),
          onTap: () => Navigator.pushNamed(context, 'FaqPage'),
        ),
        ListTile(
          leading: SvgPicture.asset(
            ThemeProvider.themeOf(context).id != 'dark' ? 'assets/brightness_low.svg' : 'assets/brightness_high.svg',
            width: 28,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text('Dark', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
