import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynovchat_flutter/Route.dart';

class WidgetTest extends StatefulWidget {
  const WidgetTest({Key? key}) : super(key: key);

  @override
  _WidgetTestState createState() => _WidgetTestState();
}

class _WidgetTestState extends State<WidgetTest> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(

       body:
           Column(
             children: [
                Spacer(),
               Container(child: Image(image: AssetImage('assets/img.png'))),

               TextFormField(),
               IconButton(onPressed: () => tester(),
                   icon: const Icon(Icons.location_on)),
               ElevatedButton(onPressed: () => myFunction(),
                   child:Container(child: SizedBox(width: 200.0,height: 200.0,child: Image(image: AssetImage('assets/img_1.png')))),

               ),
               /*ListView.builder(
                 itemCount: 2,
                 itemBuilder: (context,index) {

                   return ListTile(
                     title: Icon(Icons.add_outlined),
                   );

                 }
               )*/
               Spacer()



             ],
           )


    );


  }
void myFunction(){

}
 void tester() {
   Navigator.of(context).pushReplacementNamed(ROUTE.HOME_PAGE);
 }
}

//