import 'package:flutter/material.dart';
import 'package:wsmb_day2_try1/models/rider.dart';
import 'package:wsmb_day2_try1/pages/homePage.dart';
import 'package:wsmb_day2_try1/pages/loginPage.dart';
import 'package:wsmb_day2_try1/pages/registerPage.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  void redirectRegisterPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void redirectLoginPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
    signIn();
  }

  Future<void> signIn() async {
    var rider = await Rider.getRiderByToken();
    if (rider != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage(rider: rider)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Kongsi Kereta for Riders'),
            ElevatedButton(
                onPressed: redirectRegisterPage, child: Text('Register')),
            ElevatedButton(onPressed: redirectLoginPage, child: Text('Login')),
          ],
        ),
      ),
    );
  }
}
