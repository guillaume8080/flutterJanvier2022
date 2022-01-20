import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http ;
import 'dart:developer' as developer;

class RegisterPageNWidget extends StatelessWidget {
  // const LoginPage({Key? key}) : super(key: key);
  //late = instancié plus tard


  late TextEditingController tecId;
  late TextEditingController tecPwd;
  late TextEditingController tecEmail;

  // Comprendre ce consgrcuteur !!!!
  // ? --> optionnel
  RegisterPageNWidget({Key? key}) : super(key: key){

    // ce n'est pas un input mais un objet qui est un champ d'un widget destiné aux inputs
    tecId = new TextEditingController();

    tecPwd = new TextEditingController();

     tecEmail = new TextEditingController();


    // super(key: key);


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title : const Text("Inscription"),


      ),
      body:
        Padding(

          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Spacer(),
                _buildEmailField(),
                _buildUserName(),
                _buildPassWordFiled(),
                Spacer(),
                _buildRegisterButton(context),
                _buildLoginButton(context),
              ]
            )

          ),
        )
    );


  }

  // La fleche c est un retour
  Widget _buildEmailField() => TextFormField(


    controller:  tecEmail,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next ,
    decoration: const InputDecoration(hintText: "Email"),


  );

  Widget _buildUserName() => TextFormField(


    controller:  tecId,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next ,
    decoration: const InputDecoration(hintText: "uname"),


  );

  Widget _buildPassWordFiled() => TextFormField(


    controller:  tecPwd,
    keyboardType: TextInputType.text,
    obscureText:  true,
    textInputAction: TextInputAction.next ,
    decoration: const InputDecoration(hintText: "password"),


  );
  //  _buildRegisterButton(),
//                 _buildLoginButton(),


  Widget _buildRegisterButton(BuildContext context) => ElevatedButton(


    onPressed: () => register(tecId,tecEmail,tecPwd , context),
    child: Text("Senregister ".toUpperCase())

  );

  Widget _buildLoginButton(BuildContext context) => ElevatedButton(

      onPressed: () => login(context),
      child: Text("Se co ".toUpperCase())
  );

  }

  void register(TextEditingController tecId,TextEditingController tecEmail,TextEditingController tecPwd , BuildContext context){


    /*
    SnackBar snackBar = SnackBar(content: Text('$id:$password'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/

    Future <http.Response> res =
    http.post(
        Uri.parse("https://flutter-learning.mooo.com/auth/local/register"),
        body:{

          "email" : tecEmail.text,
          "username" : tecId.text,
          "password" : tecPwd.text

        });

    res.then((value) {
      if(value.statusCode == 200){

        //contenu map

        /*Map<String,dynamic> bodyJson =  jsonDecode(value.body);
        developer.log(bodyJson["jwt"]);*/

        developer.log("200 recu");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:Text( "inscription réussie"))
        );


        tecPwd.text = tecId.text = tecEmail.text = "";
        tecId.text = "";
        tecPwd.text = "";
        tecEmail.text = "";


      }

    },
        onError: (obj){

          developer.log("erreur lors de l enregistrement"  + obj.toString());

        }

    );




  }

  void login(BuildContext context){


    Navigator.of(context).pushReplacementNamed('/login');

  }