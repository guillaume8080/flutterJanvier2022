import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http ;
import 'dart:developer' as developer;

class RegisterPage extends StatelessWidget {
  // const LoginPage({Key? key}) : super(key: key);
  //late = instancié plus tard


  late TextEditingController tecTest;


  // Comprendre ce consgrcuteur !!!!
  // ? --> optionnel
  RegisterPage({Key? key}) : super(key: key){

    tecTest = new TextEditingController();


    // super(key: key);


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title : const Text("Inscription"),

      ) ,

      body:
      Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Center(
                  child:

                  Column(

                    children: [
                      Spacer(),

                      SizedBox(
                        width: 200.0,
                        child:
                        TextFormField(
                          controller: tecTest,
                          onChanged: (myText) => totoDisplay(context),
                        ),

                      ),
                      SizedBox(
                        width: 200.0,
                        child:
                        TextFormField(),

                      ),

                      Spacer(),

                    ],
                  )



              )

      )






      // alt entree , un wrap with s 'appelle sur un constructeur


    );
  }

  void totoDisplay(BuildContext context){

   developer.log(tecTest.text);




  }

  // toutes les methodes sont pbliques par default
  /*void _register(BuildContext context){

    String username = tecId.text;
    String password = tecPwd.text;
    String email = tecEmail.text;
    /*
    SnackBar snackBar = SnackBar(content: Text('$id:$password'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/

    Future <http.Response> res =
    http.post(
        Uri.parse("https://flutter-learning.mooo.com/auth/local/register"),
        body:{

          "email" : email,
          "username" : username,
          "password" : password

        });

    res.then((value) {
      if(value.statusCode == 200){

        //contenu map
        /*Map<String,dynamic> bodyJson =  jsonDecode(value.body);
        developer.log(bodyJson["jwt"]);*/

        developer.log("200 recu");

      }

    },
        onError: (obj){

          developer.log("erreur lors de l enregistrement"  + obj.toString());

        }

    );

    tecId.text = "";
    tecPwd.text = "";
    tecEmail.text = "";



  }*/
}
