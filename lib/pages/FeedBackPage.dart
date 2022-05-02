import 'dart:async';
import '../class_resource/StarRating.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../bloc.navigation_bloc/Route.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';
import 'package:nominatim_location_picker/src/widget/location.dart';
import 'package:nominatim_location_picker/src/widget/places_search.dart';
import 'package:nominatim_location_picker/src/widget/predictions.dart';
import 'package:nominatim_location_picker/src/services/nominatim.dart';


class MapBoxLocationPicker extends StatefulWidget  {
  MapBoxLocationPicker({
    @required this.apiKey,
    this.onSelected,
    this.searchHint = 'Search',
    this.language = 'en',
    this.location,
    this.limit = 5,
    this.country,
    this.context,
    this.height,
    this.popOnSelect = false,
    this.awaitingForLocation = "Awaiting for you current location",
    this.customMarkerIcon,
    this.customMapLayer,
  });

  final TileLayerOptions customMapLayer;
  final Widget customMarkerIcon;
  /// API Key of the MapBox.
  final String apiKey;
  final String country;
  /// Height of whole search widget
  final double height;
  final String language;
  /// Limits the no of predections it shows
  final int limit;
  /// The point around which you wish to retrieve place information.
  final Location location;
  /// Language used for the autocompletion.
  ///
  /// Check the full list of [supported languages](https://docs.mapbox.com/api/search/#language-coverage) for the MapBox API
  ///Limits the search to the given country
  ///
  /// Check the full list of [supported countries](https://docs.mapbox.com/api/search/) for the MapBox API
  /// True if there is different search screen and you want to pop screen on select
  final bool popOnSelect;
  ///Search Hint Localization
  final String searchHint;
  /// Waiting For Location Hint text
  final String awaitingForLocation;
  @override
  _MapBoxLocationPickerState createState() => _MapBoxLocationPickerState();
  ///To get the height of the page
  final BuildContext context;

  /// The callback that is called when one Place is selected by the user.
  final void Function(MapBoxPlace place) onSelected;

/// The callback that is called when the user taps on the search icon.
// final void Function(MapBoxPlaces place) onSearch;
}

class _MapBoxLocationPickerState extends State<MapBoxLocationPicker> with SingleTickerProviderStateMixin{
  var reverseGeoCoding;

  MapboxMapController mapController;
  static final CameraPosition _kInitialPosition =  CameraPosition(
    target: LatLng(41.10667683,16.87341642),
    zoom: 13.0,
  );

  CameraPosition _position = _kInitialPosition;
  List _addresses = List();
  AnimationController _animationController;

  Animation _containerHeight;

  double rating = 0;

  Position _currentPosition;
  Timer _debounceTimer;
  String _desc;
  double _lat;
  // Place options opacity.
  Animation _listOpacity;

  double _lng;

  MapBoxPlace _prediction;

  List<MapBoxPlace> _placePredictions = [];
  // MapBoxPlace _selectedPlace;
  var _selectedPlace = "";
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _debounceTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _containerHeight =
        Tween<double>(begin: 73, end: MediaQuery.of(widget.context).size.height)
            .animate(
          CurvedAnimation(
            curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
            parent: _animationController,
          ),
        );
    _listOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );
    _getCurrentLocation();


    super.initState();
  }

  _getCurrentLocation() {
    /*
    --- Função responsável por receber a localização atual do usuário
  */
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;

        _getCurrentLocationDesc();
      });
    }).catchError((e) {
      print(e);
    });
  }



  _getCurrentLocationDesc() async {
    /*
    --- Função responsável por atualizar a descrição para a referente a localização atual do usuário com base no Nominatim para evitar o reverse Geocoding
  */
    dynamic res = await NominatimService().getAddressLatLng(
        "${_currentPosition.latitude} ${_currentPosition.longitude}");
    setState(() {
      _addresses = res;
      _lat = _currentPosition.latitude;
      _lng = _currentPosition.longitude;
      _desc = _addresses[0]['description'];
    });
  }

  // Widgets
  Widget _searchContainer(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Container(
            height: _containerHeight.value,
            decoration: _containerDecoration(),
            padding: EdgeInsets.only(left: 0, right: 0, top: 15),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[

                Expanded(
                  child: Opacity(
                    opacity: _listOpacity.value,
                    child: ListView(
                      // addSemanticIndexes: true,
                      // itemExtent: 10,
                      children: <Widget>[
                        for (var places in _placePredictions)
                          _placeOption(places),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _buildAppbar() {
    /*
    --- Widget responsável constução da appbar customizada .
  */
    return new AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: _buildTextField(),

      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.blue,
        ),
        onPressed: () {
          Navigator.pop(context);
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
      ),
    );
  }

  _buildTextField() {
    /*
    --- Responsável constução do textfield de pesquisa .
  */
    return Card(
        elevation: 0,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      hintText: widget.searchHint,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey)),
                  onChanged: (value) {
                    _debounceTimer?.cancel();
                    _debounceTimer = Timer(Duration(milliseconds: 750), () {
                      if (mounted) {
                        setState(() => _autocompletePlace(value));
                      }
                    });
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _textEditingController.text == "" ? Icons.search : Icons.close,
                color: Colors.black87,
              ),
              onPressed: () {
                if (_textEditingController.text == "") {
                  return null;
                } else {
                  setState(() async{
                    await _animationController.reverse();
                    _textEditingController.text = "";
                  });
                }
              },
            ),
          ],
        ));
  }


  Widget _placeOption(MapBoxPlace prediction) {
    String place = prediction.text;
    String fullName = prediction.placeName;

    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      onPressed: () {
        setState(() {
          _selectPlace(prediction);
        });
      },
      child: ListTile(
        title: Text(
          place.length < 45
              ? "$place"
              : "${place.replaceRange(45, place.length, "")} ...",
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
          maxLines: 1,
        ),
        subtitle: Text(
          fullName,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
          maxLines: 1,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 0,
        ),
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: _textEditingController.text == "" ||
          _textEditingController.text == _selectedPlace.toString()
          ? Colors.transparent
          : Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
    );
  }

  // Methods
  void _autocompletePlace(String input) async {
    /// Will be called when the input changes. Making callbacks to the Places
    /// Api and giving the user Place options
    ///
    if (input.length > 0) {
      var placesSearch = PlacesSearch(
        apiKey: widget.apiKey,
        country: widget.country,
      );

      final predictions = await placesSearch.getPlaces(
        input,
        location: widget.location,
      );

      await _animationController.animateTo(0.5);

      setState(() => _placePredictions = predictions);

      await _animationController.forward();
    } else {
      await _animationController.animateTo(0.5);
      setState(() => _placePredictions = []);
      await _animationController.reverse();
    }
  }

  void _selectPlace(MapBoxPlace prediction) async {
    /// Will be called when a user selects one of the Place options.
    // Sets TextField value to be the location selected
    _textEditingController.value = TextEditingValue(
      text: prediction.placeName,
      selection: TextSelection.collapsed(offset: prediction.placeName.length),
    );

    // Makes animation
    await _animationController.animateTo(0.5);
    setState(() {
      _placePredictions = [];
      _selectedPlace = prediction.placeName;
      _desc = _selectedPlace;
      _prediction = prediction;
      

    });
    _animationController.reverse();
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  Widget mapContext() {
    /*
    --- Widget responsável pela representação cartográfica da região, assim como seu ponto no espaço.
  */
    final MapboxMap mapboxMap = MapboxMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
    );

    return mapboxMap;
  }



  void _bottomDialog() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return
          Container(
            color: Color(0xFF737373),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(25),
                    topRight: const Radius.circular(25),
                  )
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top:200),
                    child: SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: rating,
                      size: 40.0,
                      color: Colors.blue,
                      borderColor: Colors.blue,

                    ),
                  ),
                  Container(
                      height: 20,
                      width: 300,
                      margin: EdgeInsets.only(left:70,top: 130),
                      alignment: Alignment.topCenter,
                      child:
                      _selectedPlace!= "" ? Text(_selectedPlace,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ): Text("Bar Prova",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )

                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.topCenter,
                    child: TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        icon: Icon(Icons.comment),
                        labelText: "Commento",
                      ),
                    ),

                  ),
                  Container(

                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 50),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context,Routes.generateRoute("/SendFeedback"));
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
                        const Text('Invia Feedback', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          );

        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar:  _buildAppbar(),
      body: Stack(
       fit: StackFit.loose,

        children: <Widget>[

          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: mapContext(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: _searchContainer(context),
          ),
          Container(
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(Icons.location_on),
              iconSize: 50.4,
              color: Colors.blue,
              onPressed: (){
                _bottomDialog();
              },
            ),
          )


        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        closeManually: true,
        children: [
          SpeedDialChild(
            child: Icon(Icons.remove),
            onTap:(){
              mapController.animateCamera(
                CameraUpdate.zoomOut(),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            onTap:(){
              mapController.animateCamera(
                CameraUpdate.zoomIn(),
              );
            },
          ),

        ],

      ),
    );
  }
}

class Success extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("android/assets/images/ambrogiohead.png"),
          Icon(Icons.check,size: 100,color: Colors.blue,),
          Text("FeedBack inviato con successo",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              )
          ),
          Text("(Tocca lo schermo per ritornare sulla Dashboard)",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.normal,
                  fontSize: 15
              )
          ),
        ],
      ),

      color: Colors.white,
      onPressed: () {
        Navigator.push(context, Routes.generateRoute("/"));
      },
    );
  }
}