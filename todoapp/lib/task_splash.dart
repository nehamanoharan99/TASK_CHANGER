import 'package:flutter/material.dart';
import 'package:todoapp/task_login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNext();
  }

  void moveToNext() async {
    await Future.delayed(Duration(seconds: 3));

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRx79J9D-zp_4o7hXsa2YJkZCqxsNBSL3PKAg&s",
            width: 350,
            height: 150,
          ),
        )
      ]),
    );
  }
}
