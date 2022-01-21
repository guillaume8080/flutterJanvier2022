import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http ;
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ynovchat_flutter/Route.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage({Key? key}) : super(key: key);
  //late = instancié plus tard


  late TextEditingController tecId;
  late TextEditingController tecPwd;

  // Comprendre ce consgrcuteur !!!!
  // ? --> optionnel
  LoginPage({Key? key}) : super(key: key){

    tecId = new TextEditingController();

    tecPwd = new TextEditingController();
    // super(key: key);


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title : const Text("Connexion"),

      ) ,
      body:

      // alt entree , un wrap with s 'appelle sur un constructeur
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(

            children: [


              const Spacer(),
              // alt entree
              //
              SizedBox(
                width : 200.0,
                child: TextFormField(
                  controller: tecId,
                  decoration : const InputDecoration(

                      hintText: "Identifiant"

                ),


                ),
              ),
              SizedBox(
                width : 200.0,
                child: TextFormField(
                  controller: tecPwd,
                  decoration : const InputDecoration(

                      hintText: "Mot de passe"

                  ),
                  obscureText: true,

                ),
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () => _login(context),
                  child: Text("Se connecter".toUpperCase())
              ),
              OutlinedButton(
                  onPressed: () => _register(context),
                  // child: const Text("S'inscrire".toUpperCase()) --> impossible , il y a un calcul de fait
                  child: Text("S'inscrire".toUpperCase())
              ),


            ],

          ),
        ),
      ),

    );
  }

  // toutes les methodes sont pbliques par default
  void _login(BuildContext context){


    String id = tecId.text;
    String password = tecPwd.text;

    /*
    SnackBar snackBar = SnackBar(content: Text('$id:$password'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
    // asynchorne
    Future <http.Response> res =
    http.post(
        Uri.parse("https://flutter-learning.mooo.com/auth/local"),
    body:{

      "identifier" : id,
      "password" : password

    });

    res.then((value) async {
      if(value.statusCode == 200){

        //contenu map
        // A savoir , un docuent json est une map key value
        // Noter ici le type dynamic , on peuiut récupérer du texte comme des nombres,...
        Map<String,dynamic> bodyJson =  jsonDecode(value.body);
        developer.log(bodyJson["jwt"]);
        String token = bodyJson["jwt"];
        await FlutterSecureStorage().write(key: "jwt" , value: token).then((value) => null,

        onError: (_, error) => developer.log("erreur save token :" + error.toString() )
        );


        Navigator.of(context).pushReplacementNamed(ROUTE.HOME_PAGE);



      }

    },
     onError: (obj){

      developer.log("erreur lors de la connexion" + obj.toString());

     }

    );

    tecId.text = "";
    tecPwd.text = "";




  }

  void _register(BuildContext context){

    // Navigator.of(context).pushNamed("/register" , arguments: "toto");
  }
}
