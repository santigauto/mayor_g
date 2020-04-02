import 'package:mayor_g/models/auth/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  final _user = User();

  @override
  void initState() { 
    super.initState();
    this.validateUser();
  }

  validateUser() async {
    final _token = await _user.get();
    if (_token != null) { 
      Navigator.pushReplacementNamed(context, '/');
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      ),
    );
  }
}