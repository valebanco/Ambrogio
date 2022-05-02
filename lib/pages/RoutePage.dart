import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';
import 'package:nominatim_location_picker/src/widget/location.dart';
import 'package:nominatim_location_picker/src/widget/places_search.dart';
import 'package:nominatim_location_picker/src/widget/predictions.dart';
import 'package:nominatim_location_picker/src/services/nominatim.dart';

class MapBoxLocationPicker extends StatefulWidget {
  MapBoxLocationPicker({
    @required this.apiKey,
    this.onSelected,
    this.isEmptyText,
    this.isCheckedMyPosition,
    this.labelText,
    this.language = 'it',
    this.location,
    this.limit,
    this.country,
    this.context,
    this.height,
    this.popOnSelect = false,
    this.awaitingForLocation = "Awaiting for you current location",
    this.customMarkerIcon,
    this.customMapLayer,
  });

  //
  final TileLayerOptions customMapLayer;

  //
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
  final String labelText;

  /// Waiting For Location Hint text
  final String awaitingForLocation;

  @override
  _MapBoxLocationPickerState createState() => _MapBoxLocationPickerState();

  ///To get the height of the page
  final BuildContext context;

  /// The callback that is called when one Place is selected by the user.
  final void Function(MapBoxPlace place) onSelected;


  final void Function (bool value) isCheckedMyPosition;
  final void Function(String text) isEmptyText;


/// The callback that is called when the user taps on the search icon.
// final void Function(MapBoxPlaces place) onSearch;
}

class _MapBoxLocationPickerState extends State<MapBoxLocationPicker>
    with SingleTickerProviderStateMixin {

  var reverseGeoCoding;

  bool isSelectedMyPosition = false;

  List _addresses = List();
  AnimationController _animationController;
  // SearchContainer height.
  Animation _containerHeight;

  var c;
  Position _currentPosition;
  Timer _debounceTimer;
  String _desc;
  double _lat;
  // Place options opacity.
  Animation _listOpacity;

  double _lng;
  MapController _mapController = MapController();


  MapBoxPlace _prediction;

  List<MapBoxPlace> _placePredictions = [];
  // MapBoxPlace _selectedPlace;
  var _selectedPlace;
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
  Widget _searchContainer({Widget child}) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Container(

            height: _containerHeight.value,
            decoration: _containerDecoration(),
            padding: EdgeInsets.only(left: 0, right: 0, top: 35),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: child,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Opacity(
                    opacity: _listOpacity.value,
                    child: ListView(
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

  String getCurrentTextEditingController(){
    return _textEditingController.text;
  }



  _buildTextField() {
    /*
    --- Responsável constução do textfield de pesquisa .
  */
    return Card(
      elevation: 4,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                  labelText: widget.labelText,
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 15,color: Colors.white)),
              onChanged: (value) {
                setState(() => widget.isEmptyText(value));
                _debounceTimer?.cancel();
                _debounceTimer = Timer(Duration(milliseconds: 100), () {
                  if (mounted) {
                    setState(() => _autocompletePlace(value));
                  }
                });
              },


            ),
          ),
          IconButton(
            icon: Icon(
              _textEditingController.text != "" ? Icons.close:null,
              color: Colors.black87,
            ),
            onPressed: () {

              if (_textEditingController.text != "") {
                setState(() {
                  _textEditingController.text = "";
                  widget.isEmptyText(_textEditingController.text);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    /*
    --- Widget responsável constução das descrições de um determinado local.
  */
    return new
    Container(
      width: 200.0,
      height: 200.0,
      margin: EdgeInsets.only(top: 200.0),
      child: Card(
          elevation: 4,
          child: Row(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: Text(

                      _desc == null ? widget.awaitingForLocation : _desc,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.start,
                    ),

                  )
              ),
            ],
          )
      ),
    );
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
      if (_prediction != null) {
        widget.onSelected(_prediction);
      }
    });



    _animationController.reverse();
  }

  Widget _buildCheckBox() {
    return Container(
      width: 500,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 70),
      child: Row(

        children: <Widget>[
          Checkbox(
            value: isSelectedMyPosition,
            onChanged: (bool value){
              setState(() {
                isSelectedMyPosition = value;
                if(isSelectedMyPosition)
                  _textEditingController.text = "la mia posizione";
                else{
                  _textEditingController.text = "";
                  widget.isEmptyText("");
                }


                widget.isCheckedMyPosition(isSelectedMyPosition);
              });
            },
          ),
          Text("Usa la mia posizione")
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: <Widget>[
          _searchContainer(),
          _buildTextField(),
          widget.labelText == "Partenza" ? _buildCheckBox() : Container( width:0,height:20),
        ],
      );

  }
}