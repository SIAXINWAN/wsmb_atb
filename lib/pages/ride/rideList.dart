import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wsmb_day2_try1/models/ride.dart';
import 'package:wsmb_day2_try1/services/databaseService.dart';
import 'package:wsmb_day2_try1/widgets/rideCard.dart';

class RideListMainPage extends StatelessWidget {
  const RideListMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => 
      MaterialPageRoute(builder: (context)=>RideListPage()),
    );
  }
}

class RideListPage extends StatefulWidget {
  const RideListPage({super.key});

  @override
  State<RideListPage> createState() => _RideListPageState();
}

class _RideListPageState extends State<RideListPage> {
  
  List<Ride>rideList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRideList();
  }

  void getRideList()async{
    rideList = await DatabaseService.getRideList();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: rideList.length,
        itemBuilder: (context,index){
          return RideCard(ride: rideList[index], func: getRideList);
        }),
    );
  }
}