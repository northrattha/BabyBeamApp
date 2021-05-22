import 'dart:io';
import 'package:BabyBeamApp/home.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart' as path;
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
  final formKey = GlobalKey<FormState>(); // get email & password value
  final picker = ImagePicker();
  String firstName, lastName, nickName, sex, age = 'ปี - เดือน - วัน';
  String birthDate = 'เลือกวันเกิด';
  int ageY, ageM, ageD = 0;
  List<String> sexs = ['ชาย', 'หญิง'];
  int selectedIndex;
  File file;
  bool error = false;

  Future<void> insertValue() async {
    print("file  $file");
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

    //   String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    //  final Reference storageRef = FirebaseStorage.instance.ref().child("/Profile_image").child("imageName.jpg");
    //  final UploadTask uploadTask = storageRef.putFile(file);
    //  await uploadTask.then((TaskSnapshot taskSnapshot){
    //    taskSnapshot.ref.getDownloadURL().then((imageUrl){print('IMAGE SUCC : $imageUrl');});
    //  });
    //
    // String fileName = path.basename(file.path);
    // Reference storageRef =
    // FirebaseStorage.instance.ref().child('/upload/$fileName');
    // UploadTask uploadTask = storageRef.putFile(file);
    // await uploadTask.then((TaskSnapshot taskSnapshot) {
    //   taskSnapshot.ref.getDownloadURL().then((imageUrl) {
    //     print('IMAGE SUCC : $imageUrl');
    //   });
    // });

    await firebaseFirestore
        .collection('baby_profile')
        .doc(user.uid)
        .set(map)
        .then((value) {
      print('Insert Success');
    });
  }
  // Future<void> inserteImg() async {
  //  String imageName = DateTime.now().microsecondsSinceEpoch.toString();
  //  final Reference storageRef = FirebaseStorage.instance.ref().child("Profile_image/").child(imageName);
  //  final UploadTask uploadTask = storageRef.putFile(file);
  //  uploadTask.then((TaskSnapshot taskSnapshot){
  //    taskSnapshot.ref.getDownloadURL().then((imageUrl){print('IMAGE SUCC : $imageUrl');});
  //  });
  // }

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
          Mystyle().textButtonHeadbar('ลูกของคุณ'),
          SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('images/user128.png'),
                  ),
                ),
              ),
              // Positioned.fill(
              //   child: Align(
              //     alignment: Alignment.center,
              //     child: file == null
              //         ? Icon(
              //             Icons.account_circle,
              //             size: 140,
              //             color: greyBackground,
              //           )
              //         : Container(
              //             width: 130,
              //             height: 130,
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               image: DecorationImage(
              //                 image: FileImage(file),
              //                 fit: BoxFit.cover,
              //               ),
              //             ),
              //           ),
              //   ),
              // ),
              // Positioned.fill(
              //   child: Align(
              //     alignment: Alignment.bottomRight,
              //     child: IconButton(
              //         icon: Icon(
              //           Icons.camera,
              //           color: Colors.black54,
              //         ),
              //         onPressed: () {
              //           chooseImage(ImageSource.gallery);
              //         }),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget firstNameField() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      width: size.width * 0.36,
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: orangeBackGroundColor,
            prefixIcon: Icon(Icons.person, color: orangeButtonColor),
            hintText: 'ชื่อ',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: grayBackGroundColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: orangeButtonColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          onSaved: (String value) {
            firstName = value.trim();
          },
          validator: (String email) {
            if (!((email.contains('@')) && (email.contains('.')))) {
              // return 'Please Check Your Email';
              print('error');
              firstName = 'กรุณาตรวจสอบอีเมลอีกครั้ง';
            } else {
              firstName = null;
            }
          }),
    );
  }

  Widget lastNameField() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      width: size.width * 0.36,
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: orangeBackGroundColor,
            prefixIcon: Icon(Icons.person, color: orangeButtonColor),
            hintText: 'สกุล',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: grayBackGroundColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: orangeButtonColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          onSaved: (String value) {
            lastName = value.trim();
          },
          validator: (String email) {
            if (!((email.contains('@')) && (email.contains('.')))) {
              // return 'Please Check Your Email';
              print('error');
              lastName = 'กรุณาตรวจสอบอีเมลอีกครั้ง';
            } else {
              lastName = null;
            }
          }),
    );
  }

  Widget nickNameField() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: orangeBackGroundColor,
            prefixIcon: Icon(Icons.person, color: orangeButtonColor),
            hintText: 'ชื่อเล่น',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: grayBackGroundColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: orangeButtonColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          onSaved: (String value) {
            nickName = value.trim();
          },
          validator: (String email) {
            if (!((email.contains('@')) && (email.contains('.')))) {
              // return 'Please Check Your Email';
              print('error');
              nickName = 'กรุณาตรวจสอบอีเมลอีกครั้ง';
            } else {
              nickName = null;
            }
          }),
    );
  }

  Widget cutomRadio(String txt, int index) {
    return Row(
      children: [
        ActionChip(
            avatar: CircleAvatar(
              backgroundColor: selectedIndex == index ? white : bage,
            ),
            label: Text(
              txt,
              style: TextStyle(
                color: selectedIndex == index ? Colors.black : Colors.black,
              ),
            ),
            backgroundColor:
                selectedIndex == index ? orangeBackGroundColor : Colors.white,
            onPressed: () {
              changeIndex(index);
              sex = txt;
            }),
      ],
    );
  }

  Widget sexField() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Row(
        children: [
          Container(
            child: headTextField('  เพศ :  '),
            width: 75,
          ),
          Container(
            // color: Colors.black,
            width: 170,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cutomRadio(sexs[0], 0),
                cutomRadio(sexs[1], 1),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget selectbirth() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: headTextField('  วันเกิด :'),
                width: 75,
              ),
              datePicker(),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '              $age',
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  DateTime dateNote;
  Widget datePicker() {
    return Container(
      width: 170,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: bage,
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
          },
              currentTime: dateNote == null ? DateTime.now() : dateNote,
              locale: LocaleType.th);
        },
        child: Text(
          birthDate,
          // style: TextStyle(
          //   color: Colors.white,
          // ),
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
            // Text(
            //   'ย้อนกลับ',
            //   style: TextStyle(
            //     color: Colors.grey,
            //   ),
            // ),
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
        color: orangeBackGroundColor2,
        child: txt2('บันทึก'),
        onPressed: () {
          // if(file!=null){
          //   Image.file(file);
          // }
          print(birthDate);
          formKey.currentState.save();

          if (nickName == "" ||
              firstName == "" ||
              lastName == "" ||
              sex == null ||
              birthDate == 'เลือกวันเกิด') {
            setState(() {
              error = true;
            });
          } else {
            print(sex);
            insertValue();
            // inserteImg();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Home()),
                (Route route) => false);
          }
        },
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget content() {
    return Form(
      key: formKey,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 75, left: 50, right: 50),
        child: Column(
          children: [
            uploadImg(),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                firstNameField(),
                lastNameField(),
              ],
            ),
            nickNameField(),
            sexField(),
            selectbirth(),
            error == true
                ? SizedBox(height: 30)
                : SizedBox(
                    height: 40,
                  ),
            Visibility(
              visible: error,
              child: Column(
                children: [
                  Text(
                    '** กรุณากรอกข้อมูลให้ครบถ้วน',
                    style: TextStyle(color: redBurgandy),
                  ),
                  SizedBox(
                    height: 4,
                  )
                ],
              ),
            ),
            saveData()
          ],
        ),
      ),
    );
  }

  Widget profile() {
    return Container(
      height: size.height,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
        color: grayBackGroundColor,
        // borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      ),
      child: content(),
    );
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SizedBox(
        height: 800,
        child: Stack(
          children: [
            Container(
              height: 800,
            ),
            // Positioned(
            //   child: back(),
            //   bottom: 0,
            // ),
            profile()
          ],
        ),
      ),
    );
  }
}
