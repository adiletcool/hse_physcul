import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hse_phsycul/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _corpEmailController = TextEditingController();
  String _loadedCorpEmail;

  final _languageList = [
    {'title': 'English', 'value': 'en-US'},
    {'title': 'Русский', 'value': 'ru-RU'}
  ];
  final _themeList = ['Light', 'Dark'];
  final _qrInputModeList = ['Numeric', 'AlphaNumeric', 'Binary'];
  final _qrErrorLevelList = ['High', 'Quartile', 'Medium', 'Low'];

  String _language;
  String _theme;
  String _qrErrorLevel;
  String _qrInputMode;

  @override
  void initState() {
    super.initState();
    _qrInputMode = _qrInputModeList[0];
    _qrErrorLevel = _qrErrorLevelList[0];
    _getEmail().then((value) {
      _loadedCorpEmail = value ?? '';
      if (value != null) _corpEmailController.text = _loadedCorpEmail;
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = ThemeProvider.themeOf(context).id.capitalize();
    _language = _languageList.firstWhere((Map lang) => lang['value'] == context.locale.toLanguageTag())['value'];
  }

  void changeLanguage(String langValue) {
    context.locale = Locale(langValue.split('-')[0], langValue.split('-')[1]);
    setState(() => _language = langValue);
  }

  Future<String> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('corpEmail');
  }

  Future<void> _saveEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('corpEmail', _corpEmailController.text);
    _loadedCorpEmail = _corpEmailController.text;
    Fluttertoast.showToast(msg: 'saved'.tr());
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text("settings".tr()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 25),
          onPressed: () => Navigator.pushNamed(context, 'HomePage'),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[
              // General
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Text('general'.tr(), style: TextStyle(fontSize: 17)),
              ),
              Card(
                elevation: 4,
                child: Column(
                  children: <Widget>[
                    ExpansionTile(
                      leading: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                      title: Text("profile".tr()),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: _corpEmailController,
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              icon: SvgPicture.asset('assets/icons/email.svg', color: Theme.of(context).iconTheme.color),
                              border: InputBorder.none,
                              hintText: 'corporate_email'.tr(),
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                        _corpEmailController.text == _loadedCorpEmail
                            ? Container()
                            : FlatButton(
                                child: Text('Save'),
                                onPressed: () async => await _saveEmail(),
                              ),
                      ],
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.language, color: Theme.of(context).iconTheme.color),
                      title: Text("language".tr()),
                      children: _languageList
                          .map((Map lang) => ListTile(
                                title: Text(lang['title']),
                                onTap: () => changeLanguage(lang['value']),
                                leading: Radio(
                                  groupValue: _language,
                                  value: lang['value'],
                                  onChanged: (value) => changeLanguage(value),
                                ),
                              ))
                          .toList(),
                    ),
                    ExpansionTile(
                      leading: SvgPicture.asset(
                        _theme != 'Dark' ? 'assets/icons/brightness_low.svg' : 'assets/icons/brightness_high.svg',
                        width: 28,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text("theme".tr()),
                      children: _themeList
                          .map((String value) => ListTile(
                                title: Text(value.toLowerCase().tr()),
                                onTap: () {
                                  ThemeProvider.controllerOf(context).setTheme(value.toLowerCase());
                                  setState(() => _theme = value);
                                },
                                leading: Radio(
                                  groupValue: _theme,
                                  value: value,
                                  onChanged: (String value) {
                                    ThemeProvider.controllerOf(context).setTheme(value.toLowerCase());
                                    setState(() => _theme = value);
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              // 'QR Code Generator'
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('qr_generator'.tr(), style: TextStyle(fontSize: 17)),
              ),
              Card(
                elevation: 4,
                child: Column(
                  children: <Widget>[
                    ExpansionTile(
                      leading: SvgPicture.asset('assets/icons/input_mode.svg', width: 26, color: Theme.of(context).iconTheme.color),
                      title: Text("input_mode".tr()),
                      children: _qrInputModeList
                          .map((String value) => ListTile(
                                title: Text(value),
                                onTap: () => setState(() => _qrInputMode = value),
                                leading: Radio(
                                  groupValue: _qrInputMode,
                                  value: value,
                                  onChanged: (value) => setState(() => _qrInputMode = value),
                                ),
                              ))
                          .toList(),
                    ),
                    ExpansionTile(
                      leading: Icon(MdiIcons.qrcodeEdit, color: Theme.of(context).iconTheme.color),
                      title: Text("error_level".tr()),
                      children: _qrErrorLevelList
                          .map((String value) => ListTile(
                                title: Text(value),
                                onTap: () => setState(() => _qrErrorLevel = value),
                                leading: Radio(
                                  groupValue: _qrErrorLevel,
                                  value: value,
                                  onChanged: (value) => setState(() => _qrErrorLevel = value),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
