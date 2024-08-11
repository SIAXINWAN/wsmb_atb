import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wsmb_day2_try1/models/driver.dart';
import 'package:wsmb_day2_try1/models/ride.dart';
import 'package:wsmb_day2_try1/models/rider.dart';
import 'package:wsmb_day2_try1/models/vehicle.dart';
import 'package:wsmb_day2_try1/services/databaseService.dart';

class RideDetailsPage extends StatefulWidget {
  const RideDetailsPage({super.key, required this.ride});
  final Ride ride;

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  Driver? driver;
  Vehicle? vehicle;
  Rider?rider;
  bool isJoin =false;

  void getDetail()async{
    var res = await DatabaseService.getRideDetails(widget.ride.id!);
    rider = await Rider.getRiderByToken();
    if(res.$1 ==null || res.$2 ==null || rider ==null){
      await showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: Text('Warnign'),
          content: Text('Something went wrong'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: Text('OK'))
          ],
        ));
        Navigator.of(context).pop();
        return;
    }
    driver = res.$2;
    vehicle = res.$1;

    isJoin = widget.ride.riderIds!.contains(rider?.id??'');
    setState(() {
      
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: Column(
        children: [
          Text(driver?.name??''),
          Text(vehicle?.car_model??''),
          Text(vehicle?.capacity.toString()??'0'),
          ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, 
            child: Text('Return')),
            (isJoin)
            ?ElevatedButton(
              onPressed: ()async{
                var res = await DatabaseService.cancelRide(
                  widget.ride, vehicle!, rider!);
                  if(res ){
                    Navigator.of(context).pop();
                  }
              }, 
              child: Text('Cancel'))
              :ElevatedButton(
                onPressed: ()async{
                  var res = await DatabaseService.joinRide(
                    widget.ride, vehicle!, rider!);
                if(res ){
                    Navigator.of(context).pop();
                  }
              }, 
              child: Text('Join'))
        ],
      ),
    ));
  }
}