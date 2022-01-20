import 'package:flutter/material.dart';
import 'package:ynovchat_flutter/login_page.dart';
import 'package:ynovchat_flutter/registerPageNWidget.dart';
import 'package:ynovchat_flutter/register_page.dart';
import 'package:ynovchat_flutter/home_page.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
       //home:  RegisterPageNWidget(),

        initialRoute: '/home_page',
        routes: <String , WidgetBuilder>{

        '/login': (BuildContext context) => LoginPage(),
        '/register' : (BuildContext context) => RegisterPageNWidget(),
          '/home_page' : (BuildContext context) => HomePage(),
          '/test' : (BuildContext context) => RegisterPage()
        //'/homepage' : (BuildContext  context) => HomePage()

      }
    );
  }
}




