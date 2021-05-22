import 'package:BabyBeamApp/symptom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'components/imageProfile.dart';
import 'model/babyInfo.dart';
import 'myStyle.dart';

class SymptomHistory extends StatefulWidget {
  final List<String> list;
  final String type;

  const SymptomHistory({Key key, this.list, this.type,})
      : super(key: key);
  @override
  _SymptomHistoryState createState() => _SymptomHistoryState();
}

class _SymptomHistoryState extends State<SymptomHistory> {
  List histDrug, histFood, histDisease,list;
  Size size;
  String type;

  @override
  void initState() {
    super.initState();
    list = widget.list;
    type = widget.type;
  }

  Widget headbar() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: greenbeam,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Symptom()));
                },
              ),
              Text(
                'การแพ้และโรคประจำตัว',
                style: TextStyle(fontSize: 20),
              ),
              ImageProfile(
                size: 5,
                color: white,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget checkIndex(int index, String hist,int len) {
      return SizedBox(
        child: TimelineTile(
          alignment: TimelineAlign.start,
          endChild: timelineBox(hist),
          isFirst: true,
          isLast: true,
          // beforeLineStyle: const LineStyle(thickness: 3),
          indicatorStyle: IndicatorStyle(
              width: 30,
              height: 30,
              indicator: indicatorNew(20, hist), //30
              indicatorXY: 0.30,
              padding: EdgeInsets.only(right: 10),
              color: redBurgandy),
        ),
      );
  }

  Widget indicatorNew(double dotsize, String key) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: dotsize,
          // height: ,
          decoration: BoxDecoration(
            border: Border.all(color: purple, width: 3),
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: orangeButtonColor2,
          ),
        ),
      ],
    );
  }

  Widget timelineBox(String hist) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
      alignment: Alignment.topLeft,
      width: size.width * 0.75,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              topRight: Radius.circular(25)),
          color: grayBackGroundColor),
      child: Text(hist),
    );
  }

  Widget title(String name) {
    return Container(
      margin: EdgeInsets.only(bottom: 20,right: 200),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: greenbeam,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Center(
        child: Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget timeLine(List list, String type) {
    return Container(
      width: 360,
      padding: EdgeInsets.only(left: 30),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final history = list;
          return Container(
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.2,
              child: SizedBox(
                child: checkIndex(index, history[index],list.length),
              ),
              secondaryActions: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: redbeam,
                  ),
                  child: IconSlideAction(
                    color: Colors.transparent,
                    icon: Icons.delete,
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection(
                              "baby_profile/${BabyInfo.userID}/medical_problems/medical_problems/$type")
                          .where("name", isEqualTo: history[index])
                          .get()
                          .then((snapshot) {
                        snapshot.docs.first.reference.delete().then((value) {
                          print("Remove Success ");
                          setState(() {
                            list.removeAt(index);
                          });
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      width: 360,
      padding: EdgeInsets.only(left: 30),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final history = list;
          return Container(
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.2,
              child: SizedBox(
                child: checkIndex(index, history[index],list.length),
              ),
              secondaryActions: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: redbeam,
                  ),
                  child: IconSlideAction(
                    color: Colors.transparent,
                    icon: Icons.delete,
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection(
                              "baby_profile/${BabyInfo.userID}/medical_problems/medical_problems/$type")
                          .where("name", isEqualTo: history[index])
                          .get()
                          .then((snapshot) {
                        snapshot.docs.first.reference.delete().then((value) {
                          print("Remove Success ");
                          setState(() {
                            list.removeAt(index);
                          });
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
