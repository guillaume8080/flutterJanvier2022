import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

import 'package:http/http.dart' as http ;

import 'package:ynovchat_flutter/Message.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<int> items;
  // List<int>? items; -- peut etre null
  late StreamController<List<Message>> _streamControllerListMessages;
  late Stream<List<Message>> _streamMsgs;

  late TextEditingController tecMsg;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tecMsg = new TextEditingController();
    initializeDateFormatting("fr_FR",null);
    // bind la variabel fr short à la classe FR...
    setLocaleMessages("fr_short", FrShortMessages());
    _streamControllerListMessages = new StreamController<List<Message>>();
    _streamMsgs = _streamControllerListMessages.stream;
    fetchMessage();
  }

  @override
  //equivalent on create
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YnovChat"),

      ),
      body:
          // cet objet utilise une recyclervIEW
        // ListView.builder sinon
        Column(
          children: [
            // une liset par default prend tout lespace
            // prend la largeur
            Expanded(child: _buildList()),
            Row(
              children: [
                Expanded(child:

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: tecMsg,
                    decoration: InputDecoration(hintText: "Tapez votre message ..."),

                  ),
                )


                ),

                ElevatedButton(onPressed: () => sendMessage(), child: Icon(Icons.send))
              ],
            )
          ],
        ) ,
    );



  }

  StreamBuilder<List<Message>> _buildList() {
    return StreamBuilder<List<Message>>(
        stream: _streamMsgs,


        builder: (context, snapshot) {
          // en cas de prb
          if(snapshot.hasError){
            return const Icon(Icons.error);
          }
          if(!snapshot.hasData){
            //rond tournant
            return Center(child: const CircularProgressIndicator());
          }
          else {



            return ListView.separated(


                itemCount: snapshot.data!.length,
                separatorBuilder: (BuildContext context,
                    int index) => const Divider(/*thickness: 1.5,*/),

                itemBuilder: (context, index) =>
                    ListTile(
                      // leading:  SizedBox(child: Image.asset('assets/img.png')),
                                // Image.netWork("lien vers une image")
                      title:  Row(

                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: [

                        // ! : le champ est potentiellement null
                        Text(snapshot.data![index].author.username),
                        // la argument style set un TEXT et oui....
                        Text(formatDateString(snapshot.data![index].created_at),
                            style: const TextStyle(fontStyle: FontStyle.italic)),

                      ],
                      ),
                    subtitle : Text(snapshot.data![index].content)


                    ),

            );
          }
        }
      );
  }

  void fetchMessage(){
    Future<Response> resMsgs = get(Uri.parse("https://flutter-learning.mooo.com/messages?_limit=400"),
        headers: {"Authorization" : "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjQyNjcxMzMyLCJleHAiOjE2NDUyNjMzMzJ9.46AmdmoaNWPaYdDoR-4YImCSBNROendkxWD5_oz39Nc"}
    );
    resMsgs.then(
            (value) {

          if (value.statusCode == 200){
            String jsonBody = value.body;
            List<Message> lsMsgs = List.empty(growable: true);
            for(Map<String,dynamic> msg in jsonDecode(jsonBody)){

              lsMsgs.add(Message.fromJson(msg));

            }
            _streamControllerListMessages.sink.add(lsMsgs);

          }

        },
        onError: (_, err) => log("Erreur:" + err.toString())
    );

  }
  @override
  void dispose(){

    _streamControllerListMessages.close();
  }

  String formatDateString(String isoDate){

    //TODO parser la strinnen date
    String patternDate = "yyyy-MM-ddThh:mm:ss.SSSZ";
    DateFormat df = DateFormat(patternDate, "fr_FR");
    // on a un datetime plus une string
    DateTime dateTime = df.parse(isoDate);

    // TODO faire un time AGo

    return format(dateTime,locale: "fr_short") ;

  }

  void  sendMessage() {

    String messageToSend = tecMsg.text;
    Future<Response> resMsgs = post(Uri.parse("https://flutter-learning.mooo.com/messages" ) , body: {"content" : messageToSend },
        headers: {"Authorization" : "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjQyNjcxMzMyLCJleHAiOjE2NDUyNjMzMzJ9.46AmdmoaNWPaYdDoR-4YImCSBNROendkxWD5_oz39Nc"}
    );
    resMsgs.then((value) {
      if(value.statusCode == 200){

        log(value.statusCode.toString());


      }
      else{

        log(value.statusCode.toString());

      }

    },
        onError: (obj){

          log("erreur lors de  l envoie du message"  + obj.toString());

        }

    );


  }



}


