import 'dart:io';
import 'package:BabyBeamApp/home.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:BabyBeamApp/signIn.dart';
import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Baby_profile extends StatefulWidget {
  @override
  _Baby_profileState createState() => _Baby_profileState();
}

class _Baby_profileState extends State<Baby_profile> {
  // recorded form
  final formKey = GlobalKey<FormState>(); // get email & password value
  String firstName, lastName, nickName, sex, age = 'ปี - เดือน - วัน';
  String birthDate = 'เลือกวันเกิด';
  int ageY, ageM, ageD = 0;

  List<String> sexs = ['ชาย', 'หญิง'];
  int selectedIndex;
  final picker = ImagePicker();
  File file; // imagefile

  Future<void> insertValue() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = Map();
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['nickname'] = nickName;
    map['id'] = user.uid;
    map['sex'] = sex;
    map['birthDate'] = birthDate;
    map['ageY'] = ageY;
    map['ageM'] = ageM;
    map['ageD'] = ageD;

    await firebaseFirestore
        .collection('baby_profile')
        .doc(user.uid)
        .set(map)
        .then((value) {
      print('Insert Success');
    });
  }

// method
  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      PickedFile object = await picker.getImage(
        source: imageSource,
        maxHeight: 1000.0,
        maxWidth: 1000.0,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget uploadImg() {
    return Container(
      child: Column(
        children: [
          Mystyle().TextButtonHeadbar('เด็กใหม่'),
          SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: file == null
                      ? Icon(
                          Icons.account_circle,
                          size: 140,
                          color: yellowPastel,
                        )
                      : Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(file),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.camera,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        print('ss');
                        chooseImage(ImageSource.gallery);
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget firstNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อ :',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        enabledBorder: new UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: new UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onSaved: (String value) {
        firstName = value.trim();
      },
    );
  }

  Widget lastNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'นามสกุล :',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        enabledBorder: new UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: new UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onSaved: (String value) {
        lastName = value.trim();
      },
    );
  }

  Widget nickNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อเล่น :',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        enabledBorder: new UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: new UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onSaved: (String value) {
        nickName = value.trim();
      },
    );
  }

  Widget cutomRadio(String txt, int index) {
    return Row(
      children: [
        ActionChip(
            avatar: CircleAvatar(
              backgroundColor:
                  selectedIndex == index ? yellowPastel : greenPastel,
              // child: Icon(Icons.ac_unit_outlined),
            ),
            label: Text(
              txt,
              style: TextStyle(
                color: selectedIndex == index ? Colors.black : Colors.white,
              ),
            ),
            backgroundColor:
                selectedIndex == index ? Colors.white : Colors.black38,
            onPressed: () {
              changeIndex(index);
              sex = txt;
            }),
      ],
    );
  }

  Widget sexField() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              child: HeadTextField('เพศ :  '),
              width: 75,
            ),
            Container(
              // color: Colors.black,
              width: 190,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cutomRadio(sexs[0], 0),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  cutomRadio(sexs[1], 1),
                ],
              ),
            )
          ],
        ),
        line(1.0)
      ],
    );
  }

  Widget selectbirth() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Container(
              child: HeadTextField('วันเกิด :'),
              width: 75,
            ),
            datePicker(),
          ],
        ),
        line(1.0),
        SizedBox(
          height: 5,
        ),
        Text(
          'อายุ  :  $age',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  DateTime dateNote;
  Widget datePicker() {
    return Container(
      width: 190,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.black38,
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(1990, 1, 1),
              maxTime: DateTime.now(), onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            changeDate(date);
            print('confirm $date');
            dateNote = date;
            print('object $dateNote');
            print('object ${DateTime.now()}');
            // }, currentTime: DateTime.now(), locale: LocaleType.th);
          },
              currentTime: dateNote == null ? DateTime.now() : dateNote,
              locale: LocaleType.th);
        },
        child: Text(
          birthDate,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void changeDate(DateTime date) {
    setState(() {
      AgeDuration age2 =
          Age.dateDifference(fromDate: date, toDate: DateTime.now());
      ageY = age2.years;
      ageM = age2.months;
      ageD = age2.days;
      age = '${ageY}ปี ${ageM}เดือน ${ageD}วัน';
      print(age);
      birthDate = new DateFormat('dd MMM y').format(date).toString();
    });
  }

  Widget back() {
    return Container(
      width: 400,
      height: 100,
      child: RaisedButton(
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Column(
          children: [
            SizedBox(
              height: 72,
            ),
            Text(
              'ย้อนกลับ',
              style: TextStyle(
                // color: greenbeam,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget saveData() {
    return Container(
      width: 300,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        onPressed: () {
          formKey.currentState.save();
          print('$nickName');
          insertValue();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route route) => false);
        },
        child: txt2('บันทึก'),
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget content() {
    return Container(
      child: Form(
        key: formKey,
        child: Container(
          // width: size.width * 0.8,
          padding: EdgeInsets.only(top: 75, left: 50, right: 50),
          child: Column(
            children: [
              uploadImg(),
              SizedBox(
                height: 5,
              ),
              firstNameField(),
              lastNameField(),
              nickNameField(),
              SizedBox(
                height: 5,
              ),
              sexField(),
              SizedBox(
                height: 5,
              ),
              selectbirth(),
              const SizedBox(
                height: 30,
              ),
              saveData()
              // choiceChips()
            ],
          ),
        ),
      ),
    );
  }

  Widget profile() {
    return Container(
      child: Container(
        height: 725,
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("images/cloud.png"),
          //   fit: BoxFit.fill,
          // ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
          color: greenPastel,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50)),
        ),
        child: content(),
      ),
    );
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SizedBox(
        height: 825,
        // height: 800,
        child: Stack(
          children: [
            Container(
              height: 800,
            ),
            // profile(),
            Positioned(
              child: back(),
              // top: 700,
              bottom: 0,
            ),
            profile()
          ],
        ),
      ),
    );
  }
}
