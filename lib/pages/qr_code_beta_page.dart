import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:async/async.dart';
import 'package:collection/collection.dart';
import '../HexColor.dart';
import '../constants.dart';
import 'package:easy_localization/easy_localization.dart';

Function areListsEqual = const ListEquality().equals;

class QRCodeBetaPage extends StatefulWidget {
  QRCodeBetaPage({Key key}) : super(key: key);

  @override
  _QRCodeBetaPageState createState() => _QRCodeBetaPageState();
}

class _QRCodeBetaPageState extends State<QRCodeBetaPage> {
  final AsyncMemoizer _memoizer = AsyncMemoizer(); // asyncInit run only once

  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _groupNumController = TextEditingController();
  String _programmeName;
  String _qrCodeValue;
  SharedPreferences _prefs;

  Future<bool> asyncinit() async {
    await _memoizer.runOnce(() async {
      _prefs = await SharedPreferences.getInstance();
      await getSettings();
    });
    return true;
  }

  List readSettings() {
    return [
      _prefs.getString('_nameControllerText') ?? '',
      _prefs.getString('_surnameControllerText') ?? '',
      _prefs.getString('_groupNumControllerText') ?? '',
      _prefs.getString('_programmeName') ?? null,
    ];
  }

  Future<void> getSettings() async {
    List settings = readSettings();
    _nameController.text = settings[0];
    _surnameController.text = settings[1];
    _groupNumController.text = settings[2];
    _programmeName = settings[3];
    _saveQRCodeValue();
  }

  void _saveQRCodeValue({programme}) {
    _programmeName = programme ?? _programmeName;
    setState(() => _qrCodeValue = "${_surnameController.text} ${_nameController.text};$_programmeName${_groupNumController.text}");
  }

  Future<void> saveSettings() async {
    if (!areListsEqual(readSettings(), [_nameController.text, _surnameController.text, _groupNumController.text, _programmeName])) {
      await _prefs.setString('_nameControllerText', _nameController.text);
      await _prefs.setString('_surnameControllerText', _surnameController.text);
      await _prefs.setString('_groupNumControllerText', _groupNumController.text);
      await _prefs.setString('_programmeName', _programmeName);
      Fluttertoast.showToast(msg: 'saved'.tr());
    }
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
            backgroundColor: Theme.of(context).appBarTheme.color,
            child: SvgPicture.asset('assets/icons/settings.svg', color: HexColor.fromHex('#f5f7f9'), width: 25),
            onPressed: () => showParamsBottomSheet(),
          ),
          body: SafeArea(
            child: FutureBuilder<bool>(
                future: asyncinit(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == false) return Center(child: CircularProgressIndicator());

                  return Stack(
                    children: [
                      Center(child: getMainBody()),
                      Positioned(
                        top: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, size: 30),
                          onPressed: () => Navigator.pushNamed(context, 'HomePage'),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ));
  }

  Widget getMainBody() {
    if (_nameController.text == '' || _surnameController.text == '' || _groupNumController.text == '' || _programmeName == null)
      return GestureDetector(
        onTap: () => showParamsBottomSheet(),
        child: SvgPicture.asset('assets/images/add_user.svg', width: MediaQuery.of(context).size.width - 50),
      );
    else
      return Container(
        height: 300,
        child: SfBarcodeGenerator(
          value: _qrCodeValue,
          barColor: Theme.of(context).iconTheme.color,
          showValue: true,
          symbology: QRCode(
            codeVersion: QRCodeVersion.auto,
            // errorCorrectionLevel: ErrorCorrectionLevel.low,
          ),
        ),
      );
  }

  void showParamsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => myBottomSheet(),
      backgroundColor: Colors.transparent,
    ).then((value) async => await saveSettings());
  }

  Widget myBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        right: 15,
        left: 15,
        bottom: (MediaQuery.of(context).viewInsets.bottom == 0) ? 15 : MediaQuery.of(context).viewInsets.bottom + 5,
      ),
      child: StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'set_parameters'.tr(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  IconButton(
                    tooltip: 'Clear all',
                    icon: Icon(MdiIcons.eraserVariant, color: HexColor.fromHex('#cb3b3b'), size: 30),
                    // icon: SvgPicture.asset('assets/icons/clear_circle.svg', width: 30, color: HexColor.fromHex('#85203b')),
                    onPressed: () => clearButtonAction(),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'hint_name'.tr()),
                maxLines: 1,
                onChanged: (value) => _saveQRCodeValue(),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _surnameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'hint_surname'.tr()),
                maxLines: 1,
                onChanged: (value) => _saveQRCodeValue(),
              ),
              SizedBox(height: 15),
              DropdownButton<String>(
                isExpanded: true,
                value: _programmeName,
                hint: Text('hint_programme'.tr()),
                items: eduPrograms
                    .map(
                      (Map program) => DropdownMenuItem<String>(
                        child: Text(tr(program['name'])),
                        value: program['value'],
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _saveQRCodeValue(programme: value)),
              ),
              SizedBox(height: 15),
              TextFormField(
                // TODO: groupNum is also must be changed ('177C')
                controller: _groupNumController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'hint_group_number'.tr()),
                maxLines: 1,
                onChanged: (value) => _saveQRCodeValue(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearButtonAction() {
    setState(() {
      _nameController.text = '';
      _surnameController.text = '';
      _programmeName = null;
      _groupNumController.text = '';
    });
  }
}
