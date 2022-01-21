import 'package:flutter/material.dart';
import 'package:ynovchat_flutter/page/map_page.dart';
import 'package:ynovchat_flutter/page/login_page.dart';
import 'package:ynovchat_flutter/page/registerPageNWidget.dart';
import 'package:ynovchat_flutter/page/register_page.dart';
import 'package:ynovchat_flutter/page/home_page.dart';
import 'package:ynovchat_flutter/Route.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlng/latlng.dart';



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

        //swatch : palette de couleurs
        primarySwatch: Colors.blue,
        /*textTheme: TextStyle(
          headline1: TextStyle(fontFamily: )...
        )*/

      ),
       // Theme lorsque l os est en mode nuit
       darkTheme: ThemeData.dark(),
       //home:  RegisterPageNWidget(),

        onGenerateRoute: (settings){

          if(settings.name == ROUTE.MAP_PAGE){

            return MaterialPageRoute(builder: (context) =>

            //
            MapPage(settings.arguments as LatLng)

            );

          }


        },

        initialRoute: '/home_page',
        routes: <String , WidgetBuilder>{

        '/login': (BuildContext context) => LoginPage(),
        '/register' : (BuildContext context) => RegisterPageNWidget(),
          '/home_page' : (BuildContext context) => HomePage(),
          '/test' : (BuildContext context) => RegisterPage(),
          /*ROUTE.MAP_PAGE : (BuildContext context) => MapPage(),
          'mapPage' : (BuildContext context) => MapPage(),*/
        //'/homepage' : (BuildContext  context) => HomePage()

      }
    );
  }
}




