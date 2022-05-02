import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'SearchList.dart';
import 'SearchPage.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import '../class_resource/InformationPlace.dart';

class SearchOption extends StatefulWidget {

  @override
  InputLocationState createState() => InputLocationState();
}
class InputLocationState extends State<SearchOption> {
  InformationPlace start;
  InformationPlace destination;
  MapboxNavigation _directions;
  var textstart = "";
  var textDestination = "";
  var textBoxBuilded ;
  String textError = "";
  double _distanceRemaining, _durationRemaining;



  Widget getLocationWithMapBox(BuildContext context) {
    textBoxBuilded = new MapBoxLocationPicker(
      popOnSelect: true,
      apiKey: "pk.eyJ1IjoidmFsZWJhbmNvIiwiYSI6ImNqeGFrd21naTE3eDk0MXV0eTh1Z3B5bjUifQ._Ey1RoHlC0VY0wZr7y2O8Q",
      limit: 10,
      language: 'it',
      country: 'it',
      labelText: 'Ricerca',
      isEmptyText: (text){
        setState(() {textstart = text; });
      },
      onSelected: (place) {
        setState(() {
          start = new InformationPlace
            (place.placeName,
              place.geometry.coordinates[0],
              place.geometry.coordinates[1]);
        });
      },
      isCheckedMyPosition: (value) async{
        if (value){
          textstart = "la mia posizione";
          Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
          start = new InformationPlace("la mia posizione", position.longitude, position.latitude);

        }
      },
      context: context,
    );

    return textBoxBuilded;

  }


  String sendResponseAndView(int response)  {
    String r = "";
    switch(response) {
      case 1:
        r = "inserire i campi di partenza e destinazione";
        break;
      case 2:
        r = "inserire la partenza";
        break;
      case 3:
        r = "inserire la destinazione";
        break;
      case 4:
        r = "dati non inseriti correttamente";
        break;
    }
    return r;
  }

  void startNavigation() async{
    List<InformationPlace> routes = new List<InformationPlace>();
    routes.add(start);
    routes.add(destination);

    var _origin = Location(name: routes.elementAt(0).name,
        latitude: routes.elementAt(0).coordinate2,
        longitude: routes.elementAt(0).coordinate1);
    var _destination = Location(name: routes.elementAt(1).name,
        latitude: routes.elementAt(1).coordinate2,
        longitude: routes.elementAt(1).coordinate1);

    await _directions.startNavigation(
        origin: _origin,
        destination: _destination,
        mode: NavigationMode.drivingWithTraffic,
        simulateRoute: true, language: "Italian");

  }

  int  getResponseNumber(){
    if(((start != null)&&(destination != null))
        && ((textDestination != "") && (textstart != ""))) {
      return 0;
    }

    if((textstart == "") && (textDestination == "")){
      print("inserire i campi di partenza e destinazione");

      return 1;
    } else {
      if ((textstart == "")) {
        print("inserire i dati della partenza");
        return 2;
      } else if (textDestination == ""){
        print("inserire i dati della destinazione");
        return 3;
      } else { return 4;}
    }


  }

  Future<void> initPlatformState() async {
    bool _arrived = false;
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapboxNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived)
      {
        await Future.delayed(Duration(seconds: 3));
        await _directions.finishNavigation();
      }
    });

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }


  }
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {


    return
      Scaffold(
        resizeToAvoidBottomInset : false,
        body:Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 25),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 100),
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'android/assets/images/ambrogiohead.png',
                ),
              ),



              Container(
                width: 300.0,
                margin: EdgeInsets.only(left:50.0,right: 50.0, top:250.0),
                alignment: Alignment.topRight,
                child:getLocationWithMapBox(context),
              ),


              Container(
                width: 200.0,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(left:100.0,bottom: 200.0),

                child: RaisedButton(
                  onPressed: () {
                    /*var result = getResponseNumber();
                    result == 0 ? setState(() {textError = "";startNavigation();}) : setState(() { textError = sendResponseAndView(result);});*/
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>  SearchList(),
                    ),);
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child:
                    const Text('Avvia Ricerca', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 220),
                child: Text('$textError', style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.red,)),

              ),
            ],
          ),
        ),
      );



  }
}