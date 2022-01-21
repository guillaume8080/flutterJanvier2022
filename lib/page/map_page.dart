import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';
import 'package:cached_network_image/cached_network_image.dart';


class MapPage extends StatefulWidget {

  final LatLng location;
  // Cette classe hérite de la classe Stzte MApPagee qui prend longitude et lattotude en argument de constrcuteur
  const MapPage(this.location,{Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late MapController controller;

  // On peut instancier une classe sans widget mais pa de widget sans class , d ou init ava v build widget x
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = MapController(location: widget.location);
  }

  @override
  Widget build(BuildContext theContext) {
    return Scaffold(
      body: Map(
        controller: controller,
        builder: (context,x,y,z) {
          // Ces arguments servent aux systèmes de tuiles __> cf photo du  21/01
          // z = zoom  x lat y long
          final url = "https://tile.openstreetmap.org/$z/$x/$y.png";

          return CachedNetworkImage(imageUrl: url,fit: BoxFit.cover,);
        },

      ),
    );
  }



}
