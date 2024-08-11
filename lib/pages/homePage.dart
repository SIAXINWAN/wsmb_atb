import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wsmb_day2_try1/models/driver.dart';
import 'package:wsmb_day2_try1/models/rider.dart';
import 'package:wsmb_day2_try1/pages/ride/rideList.dart';
import 'package:wsmb_day2_try1/pages/startPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.rider});
  final Rider rider;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> logout() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Log Out'),
                content: Text('Do you want to log out?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: Navigator.of(context).pop, child: Text('No')),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      await Driver.signOut();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => StartPage()));
                    },
                  ),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          titleSpacing: 10,
          toolbarHeight: 60,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('KONGSI KERETA for RIDER'),
              GestureDetector(
                onTap: () {
                  logout();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.purple,
                  radius: 30,
                ),
              )
            ],
          )),
      body: RideListMainPage(),
    );
  }
}
