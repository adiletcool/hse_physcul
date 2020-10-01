import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hse_phsycul/config/config.dart';
import 'package:hse_phsycul/constants.dart';
import 'package:hse_phsycul/pages/faq.dart';
import 'package:hse_phsycul/pages/qr_code_beta_page.dart';
import 'package:hse_phsycul/pages/qr_code_page.dart';
import 'package:hse_phsycul/pages/schedule.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'HexColor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
// import 'package:syncfusion_flutter_core/core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // SyncfusionLicense.registerLicense(sfLicenseKey);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      routes: {
        'HomePage': (context) => MyHomePage(),
        'QRCodePage': (context) => QRCodePage(),
        'QRCodeBetaPage': (context) => QRCodeBetaPage(),
        'SchedulePage': (context) => MyScheduleClass(),
        'FaqPage': (context) => FaqMarkDown(),
      },
      localizationsDelegates: [GlobalMaterialLocalizations.delegate, SfGlobalLocalizations.delegate],
      supportedLocales: [const Locale('ru')],
      locale: const Locale('ru'),
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
                child: Container(height: 1200),
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
      backgroundColor: HexColor.fromHex('#efecec'),
      leading: IconButton(
        icon: Icon(Icons.menu, color: myDarkColor, size: 30),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        title: Text('HSE PE', style: TextStyle(color: myDarkColor)),
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
          leading: Icon(MdiIcons.qrcodeScan, color: myDarkColor, size: 24),
          onTap: () => Navigator.pushNamed(context, 'QRCodePage'),
        ),
        ListTile(
          title: Text('QR-code Beta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: Icon(MdiIcons.qrcodeScan, color: myDarkColor, size: 24),
          onTap: () => Navigator.pushNamed(context, 'QRCodeBetaPage'),
        ),
        ListTile(
          title: Text('Journal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/calendar_check.svg', width: 24, color: myDarkColor),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => MyWebViewScaffold('Attendance tracking', trackAttendanceUrl),
            ),
          ),
        ),
        ListTile(
          title: Text('Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/calendar_days.svg', width: 24, color: myDarkColor),
          onTap: () => Navigator.pushNamed(context, 'SchedulePage'),
        ),
        ListTile(
          title: Text('Train at home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/home.svg', width: 24, color: myDarkColor),
          onTap: () async => await launch(homeTrainingsUrl),
        ),
        ListTile(
          title: Text('Hike', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: Icon(MdiIcons.hiking, color: myDarkColor, size: 24),
          onTap: () {
            //TODO: hike
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Not implemented yet');
          },
        ),
        Divider(color: myDarkColor.withOpacity(.5)),
        ListTile(
          title: Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/settings.svg', width: 24, color: myDarkColor),
          onTap: () {},
        ),
        ListTile(
          title: Text('FAQ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: SvgPicture.asset('assets/faq.svg', width: 24, color: myDarkColor),
          onTap: () => Navigator.pushNamed(context, 'FaqPage'),
        ),
      ],
    );

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: HexColor.fromHex('#f5f7f9'),
      ),
      child: Container(
        width: 260,
        child: Drawer(
          child: drawerItems,
        ),
      ),
    );
  }
}
