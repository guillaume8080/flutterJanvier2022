import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

import 'package:http/http.dart' as http ;
import 'package:url_launcher/url_launcher.dart';
import 'package:ynovchat_flutter/Route.dart';

import 'package:ynovchat_flutter/bo/Message.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlng/latlng.dart';

import 'package:image_picker/image_picker.dart';



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
  late String token;
  late Map<String, String> allValues;
  final ImagePicker ip = ImagePicker();
  late String messageDefinit;


  late TextEditingController tecMsg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = "";
    recupToken();


    tecMsg = new TextEditingController();
    initializeDateFormatting("fr_FR", null);
    // bind la variabel fr short à la classe FR...
    setLocaleMessages("fr_short", FrShortMessages());
    _streamControllerListMessages = new StreamController<List<Message>>();
    _streamMsgs = _streamControllerListMessages.stream;
    fetchMessage(context);
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
              IconButton(onPressed: () => geoLocaliser(),
                  icon: const Icon(Icons.location_on)),
              IconButton(
                  onPressed: () => pickImage(), icon: const Icon(Icons.image)),
              Expanded(child:


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: tecMsg,
                  decoration: InputDecoration(
                      hintText: "Tapez votre message ..."),

                ),
              )


              ),

              ElevatedButton(
                  onPressed: () => sendMessage(), child: Icon(Icons.send)),


            ],
          )
        ],
      ),
    );
  }

  StreamBuilder<List<Message>> _buildList() {
    return StreamBuilder<List<Message>>(
        stream: _streamMsgs,


        builder: (context, snapshot) {
          // en cas de prb
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          }
          if (!snapshot.hasData) {
            //rond tournant
            return Center(child: const CircularProgressIndicator());
          }
          else {
            return ListView.separated(


              itemCount: snapshot.data!.length,
              separatorBuilder: (BuildContext context,
                  int index) => const Divider(/*thickness: 1.5,*/),

              itemBuilder: (context, index) =>


              // Tu net set pas un message mais tputes la ListTile
              InkWell(

                // la reoturne la fonction
                onTap: () => _launchUrl(snapshot.data![index].content),
                //Ne peut rien renoyer oDoutleTap attend un argumenbt
                // onDoubleTap: _launchUrl(snapshot.data![index].content),

                // la cree une fonction , entre les crochets , qui va appeller lauchurl
                // onTap: ()  {_launchUrl(snapshot.data![index].content)},


                child: ListTile(
                  // leading:  SizedBox(child: Image.asset('assets/img.png')),
                  // Image.netWork("lien vers une image")
                    title: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        // ! : le champ est potentiellement null
                        Text(snapshot.data![index].author.username),
                        // la argument style set un TEXT et oui....
                        Text(formatDateString(snapshot.data![index].created_at),
                            style: const TextStyle(
                                fontStyle: FontStyle.italic)),

                      ],
                    ),
                    subtitle: Text('${snapshot.data![index].content}')


                ),
              ),

            );
          }
        }
    );
  }

  void _launchUrl(String content) {
    //parse si url
    RegExp urlRegex = RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    RegExp latLngRegex = RegExp(r"^(-?\d+(\.\d+)?),\s*(-?\d+(\.\d+)?)$");

    bool isUri = urlRegex.hasMatch(content);
    bool isGeoLocation = latLngRegex.hasMatch(content);

    if (isUri == true) {
      // firstMatch : doit extraire une url du contenu -- c est le cas ...
      launch(urlRegex.firstMatch(content)?.group(0) ?? "");
    }
    else {
      // gruoe 0 reciupere la peremier iteration
      // le ? signifie que ce n est pas nul
      String? latLngUri = latLngRegex.firstMatch(content)?.group(0);

      if (latLngUri != null) {
        //lance un service google
        // les crochets semblent faire un toStrinbg
        //launch('geo:${latLngUri}');

        double lagitude = double.parse(latLngUri.split(",")[0]);
        String longitude = latLngUri.split(",")[1];
        if (longitude != null) {
          double longitudeDouble = double.parse(longitude);
          Navigator.of(context).pushNamed(
              ROUTE.MAP_PAGE,
              // Checker le main pour voir ce qu on fait de ces argume,nst --> generated rpute
              arguments: LatLng(lagitude, longitudeDouble)
          );
        }
      }
    }
  }

  void fetchMessage(BuildContext context) async {
    String jwt = await FlutterSecureStorage().read(key: "jwt") ?? "";
    if (jwt.isEmpty) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
    Future<Response> resMsgs = get(
        Uri.parse("https://flutter-learning.mooo.com/messages?_limit=400"),
        headers: {"Authorization": "Bearer " + jwt}
    );


    resMsgs.then(
      // value = response apres requee
            (value) {
          if (value.statusCode == 200) {
            String jsonBody = value.body;
            List<Message> lsMsgs = List.empty(growable: true);
            for (Map<String, dynamic> msg in jsonDecode(jsonBody)) {
              lsMsgs.add(Message.fromJson(msg));
            }
            _streamControllerListMessages.sink.add(lsMsgs);
          }
        },
        onError: (_, err) => log("Erreur:" + err.toString())
    );
  }

  @override
  void dispose() {
    _streamControllerListMessages.close();
  }

  String formatDateString(String isoDate) {
    //TODO parser la strinnen date
    String patternDate = "yyyy-MM-ddThh:mm:ss.SSSZ";
    DateFormat df = DateFormat(patternDate, "fr_FR");
    // on a un datetime plus une string
    // parseUTC set l objet avec le timezone du telephone
    DateTime dateTime = df.parseUTC(isoDate).toLocal();

    // TODO faire un time AGo

    return format(dateTime, locale: "fr_short");
  }

  void sendMessage() {
    String messageToSend = tecMsg.text;
    if (tecMsg.value.text
        .trim()
        .isEmpty) {
      return;
    }
    Future<Response> resMsgs = post(
        Uri.parse("https://flutter-learning.mooo.com/messages"),
        body: {"content": messageToSend},
        headers: {
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjQyNjcxMzMyLCJleHAiOjE2NDUyNjMzMzJ9.46AmdmoaNWPaYdDoR-4YImCSBNROendkxWD5_oz39Nc"
        }
    );
    resMsgs.then((value) {
      if (value.statusCode == 200) {
        log(value.statusCode.toString());
        fetchMessage(context);
        tecMsg.text = "";
      }
      else {
        log(value.statusCode.toString());
      }
    },
        onError: (obj) {
          log("erreur lors de  l envoie du message" + obj.toString());
        }

    );
  }

  void recupToken() async {


  }

  /*Future<Position> _getFix(){

   }*/

  void geoLocaliser() async {
    // class static!!!!
    // await s oppose .then
    // await est bloquant, on ne peut appelr de methode comme le .then
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Geolocator.requestPermission();
    }
    else if (permission == LocationPermission.deniedForever) {
      return;
    }
    if (serviceEnabled && permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // une fonction peut donc etre argument d une methode ...
      Geolocator.getCurrentPosition().then((position) {
        tecMsg.text = '${position.latitude } , ${position.longitude}';
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("votre position a ét récup"))
        );
      },
          // arguent error
          onError: (error, stacktrace) => {log("error: ${error.toString()} ")}
      );
    }
  }

  void pickImage() async {
    XFile? imagePicked = await
    ip.pickImage(source: ImageSource.gallery);
    if(imagePicked != null){
      log("image picked name :" + imagePicked.name);
      Uint8List imageBytes = await imagePicked.readAsBytes();
      base64UrlEncode(imageBytes.toList());
    }


  }
}

