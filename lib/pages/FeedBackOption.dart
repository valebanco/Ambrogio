
import 'package:flutter/material.dart';
import 'FeedBackPage.dart';
import '../class_resource/InformationPlace.dart';



class FeedBackOption extends StatefulWidget{

  @override
  FeedBackOptionState createState() => FeedBackOptionState();

}

class FeedBackOptionState extends State<FeedBackOption> {
  InformationPlace placeSelected;

  @override
  void initState() {
    super.initState();
  }

  Widget getLocationWithMapBox(BuildContext context) {
    MapBoxLocationPicker textBoxBuilded = new MapBoxLocationPicker(
      popOnSelect: true,
      apiKey: "pk.eyJ1IjoidmFsZWJhbmNvIiwiYSI6ImNqeGFrd21naTE3eDk0MXV0eTh1Z3B5bjUifQ._Ey1RoHlC0VY0wZr7y2O8Q",
      limit: 10,
      language: 'it',
      country: 'it',
      searchHint: 'Cerca',
      onSelected: (place) {
        setState(() {
          placeSelected = new InformationPlace
            (place.placeName,
              place.geometry.coordinates[0],
              place.geometry.coordinates[1]);
        });
      },
      context: context,
    );
    return textBoxBuilded;

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: getLocationWithMapBox(context),
    );
  }

}
