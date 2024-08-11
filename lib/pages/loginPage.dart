import 'package:flutter/material.dart';
import 'package:wsmb_day2_try1/models/rider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final icnoController = TextEditingController();
    final passwordController = TextEditingController();
    final formkey = GlobalKey<FormState>();

   Future<void>login()async{
    if(formkey.currentState!.validate()){
      var rider = await Rider.login(icnoController.text,passwordController.text);
      if(rider ==null){
        await showDialog(
          context: context, 
          builder: (context)=>AlertDialog(
            title: Text('Warning'),
            content: Text('Invalid Login'),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                } ,
                child: Text('OK'))
            ],
          ));
          return;
      }else{
        await showDialog(
          context: context, 
          builder: (context)=>AlertDialog(
            title: Text('Success'),
            content: Text('Login Successful'),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                } ,
                child: Text('OK'))
            ],
          ));
          Navigator.of(context).pop();
      }
    }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: formkey,
            child: Wrap(
              spacing: 30,
              children: [
                TextFormField(
                  controller: icnoController,
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return 'Please enter your IC number';
                    }else if(value.length !=12){
                      return 'Please enter valid ic number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'IC number'),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return 'Please enter your password';
                    }
                    
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(height: 50,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.primaries[4]
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.primaries[4]
                    ),
                    onPressed: login, 
                    child: Text('Login',style: TextStyle(
                      color: Colors.white
                    ),)),
                )
              ],
            )),
        ),
      ),
    );
  }
}