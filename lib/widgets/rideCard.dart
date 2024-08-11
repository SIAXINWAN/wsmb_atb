import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wsmb_day2_try1/models/ride.dart';
import 'package:wsmb_day2_try1/models/rider.dart';
import 'package:wsmb_day2_try1/pages/ride/rideDetails.dart';
import 'package:wsmb_day2_try1/services/databaseService.dart';

class RideCard extends StatefulWidget {
  const RideCard({super.key, required this.ride, required this.func});
  final Ride ride;
  final Function func;

  @override
  State<RideCard> createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {

  bool isJoin =false;
  @override
  String info = '';
  void initState() {
    // TODO: implement initState
    super.initState();
    updateIsJoin();
  }

  void updateIsJoin()async{
    var id = await Rider.getRiderByToken();
    isJoin = widget.ride.riderIds!.contains(id?.id??'');
    var res = await DatabaseService.getRideDetails(widget.ride.id!);
    info = 'People join: '+(widget.ride.riderIds!.length).toString()+ '/${res.$1!.capacity}';
  setState(() {
    
  });
  }
  @override
  Widget build(BuildContext context) {
    updateIsJoin();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black,width: 2),color: (isJoin)?Colors.green:Colors.white,),
      width:double.infinity,
      height: MediaQuery.of(context).size.height *0.15,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date ${widget.ride.date}'),
              Text('Fare ${widget.ride.fare.toStringAsFixed(2)}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Origin ${widget.ride.origin}'),
                  Text('Destination ${widget.ride.destination}')
                ],
              ),
              Text(info),
            ],
          ),),
          SizedBox(width: 30,),
          ElevatedButton(
            onPressed: ()async{
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context)=>RideDetailsPage(ride:widget.ride)));
                await widget.func();
            },
            child: Text('Details'))
        ],
      ),
      );
    
  }
}