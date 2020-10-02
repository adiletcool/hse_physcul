import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hse_phsycul/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _languageList = ['English', 'Russian'];
  final _themeList = ['Dark', 'Light', 'System'];
  final _qrInputModeList = ['Numeric', 'AlphaNumeric', 'Binary'];
  final _qrErrorLevelList = ['High', 'Quartile', 'Medium', 'Low'];

  String _language;
  String _theme;
  String _qrErrorLevel;
  String _qrInputMode;

  @override
  void initState() {
    super.initState();
    // read
    _language = _languageList[0];
    _theme = _themeList[0];
    _qrInputMode = _qrInputModeList[0];
    _qrErrorLevel = _qrErrorLevelList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myDarkColor,
        toolbarHeight: 50,
        title: Text("Settings"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade200, size: 25),
          onPressed: () => Navigator.pushNamed(context, 'HomePage'),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade200,
          child: ListView(
            children: <Widget>[
              // General
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Text('General', style: TextStyle(color: Colors.grey.shade700, fontSize: 17)),
              ),
              Card(
                color: Colors.white,
                elevation: 4,
                child: Column(
                  children: <Widget>[
                    ExpansionTile(
                      leading: Icon(Icons.person, color: Colors.black.withOpacity(.6)),
                      title: Text("Profile"),
                      trailing: Icon(Icons.arrow_right),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              icon: SvgPicture.asset('assets/email.svg', color: Colors.black.withOpacity(.6)),
                              border: InputBorder.none,
                              hintText: 'Corporate email',
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.language, color: Colors.black.withOpacity(.6)),
                      title: Text("Language"),
                      trailing: Icon(Icons.arrow_right),
                      children: _languageList
                          .map((String value) => ListTile(
                                title: Text(value),
                                onTap: () => setState(() => _language = value),
                                leading: Radio(
                                  groupValue: _language,
                                  value: value,
                                  onChanged: (value) => setState(() => _language = value),
                                ),
                              ))
                          .toList(),
                    ),
                    ExpansionTile(
                      leading: SvgPicture.asset('assets/brightness_low.svg', width: 26, color: Colors.black.withOpacity(.6)),
                      title: Text("Theme"),
                      trailing: Icon(Icons.arrow_right),
                      children: _themeList
                          .map((String value) => ListTile(
                                title: Text(value),
                                onTap: () => setState(() => _theme = value),
                                leading: Radio(
                                  groupValue: _theme,
                                  value: value,
                                  onChanged: (value) => setState(() => _theme = value),
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
                child: Text('QR Generator', style: TextStyle(color: Colors.grey.shade700, fontSize: 17)),
              ),
              Card(
                color: Colors.white,
                elevation: 4,
                child: Column(
                  children: <Widget>[
                    ExpansionTile(
                      leading: SvgPicture.asset('assets/input_mode.svg', width: 26, color: Colors.black.withOpacity(.6)),
                      title: Text("Input Mode"),
                      trailing: Icon(Icons.arrow_right),
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
                      leading: Icon(MdiIcons.qrcodeEdit, color: Colors.black.withOpacity(.6)),
                      title: Text("Error level"),
                      trailing: Icon(Icons.arrow_right),
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
