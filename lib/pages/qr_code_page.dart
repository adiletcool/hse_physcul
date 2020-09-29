import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hse_phsycul/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRCodePage extends StatefulWidget {
  QRCodePage({Key key}) : super(key: key);
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  File _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getImagePath().then((imagePath) {
      if (imagePath != null) setState(() => this._imageFile = File(imagePath));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, 'HomePage');
        return;
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: myDarkColor, size: 30),
                    onPressed: () => Navigator.pushNamed(context, 'HomePage'),
                  ),
                  Spacer(),
                  ButtonBar(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset('assets/camera.svg', width: 30, color: myDarkColor),
                        onPressed: () async => await _pickImageFromCamera(),
                      ),
                      IconButton(
                        icon: SvgPicture.asset('assets/album.svg', width: 30, color: myDarkColor),
                        onPressed: () async => await _pickImageFromGallery(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 50),
              Container(
                height: 370,
                child: getImageBody(),
              ),
              SizedBox(height: 40),
              Center(
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: myDarkColor),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: ListTile(
                    title: Text('Create new QR-code',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: myDarkColor,
                        )),
                    trailing: Icon(MdiIcons.qrcodePlus, color: myDarkColor),
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: 'Do not forget to take a screenshot.',
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => MyWebViewScaffold('Create QR-code', createQRCodeUrl),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageBody() {
    return this._imageFile == null ? SvgPicture.asset('assets/image.svg') : Image.file(this._imageFile, fit: BoxFit.fitHeight);
  }

  Future<Null> _pickImageFromCamera() async {
    final PickedFile pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await saveImagePath(pickedFile.path);
      setState(() => this._imageFile = File(pickedFile.path));
    }
  }

  Future<Null> _pickImageFromGallery() async {
    final PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await saveImagePath(pickedFile.path);
      setState(() => this._imageFile = File(pickedFile.path));
    }
  }

  Future<void> saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('saved image path $imagePath');
    await prefs.setString('imagePath', imagePath);
  }

  Future<String> getImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imagePath = prefs.getString('imagePath');
    print('got image path $imagePath');
    return imagePath;
  }
}
