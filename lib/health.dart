import 'dart:math';

import 'package:flutter/material.dart';

import 'components/imageProfile.dart';
import 'myStyle.dart';

class HealthPage extends StatefulWidget {
  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  Widget HeadInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        // top: 150,
        top: 130,
      ),
      child: Column(
        children: [
          ImageProfile(
            size: 100.0,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'ddd',
            style: TextStyle(color: Colors.grey.shade800, fontSize: 25),
          ),
          Text(
            'สำหรับช่วงอายุ ปี เดือน',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            pinned: true, // still show on head
            flexibleSpace: LayoutBuilder(
              builder: (context, bc) {
                double size = min(
                    // bc.constrainHeight() - MediaQuery.of(context).padding.top,
                    bc.constrainHeight(),
                    120);
                return FlexibleSpaceBar(
                  // centerTitle: true,
                  background: Center(
                    // child: Container(
                    //   width: size,
                    //   height: size,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     image: DecorationImage(
                    //       image: NetworkImage(
                    //           'https://i.loli.net/2019/08/09/OvVzMqpF3jmI8lE.jpg'),
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                    child: Stack(children: [
                      Container(
                        // height: 300,
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        color: purpleBackGroundColor,
                        padding: EdgeInsets.only(top: 80),
                        child: Mystyle().TextButtonHeadbar('Vaccine'),
                      ),
                      // Positioned.fill(
                      //   top: 200,
                      //   child: contentVaccine(),
                      // ),
                      HeadInfo(),
                    ]),
                  ),
                );
              },
            ),
          ),
          SliverList(
            //
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  title: Text("Text"),
                );
              },
              childCount: 100,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
