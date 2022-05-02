import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loggingoogle/pages/SegnalationOption.dart';
import 'PositionOption.dart';
import 'FeedBackOption.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter/widgets.dart';
import '../class_resource/InformationPlace.dart';
import 'package:geolocator/geolocator.dart';


class SearchList extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Risultati',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Risultati'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SlidableController slidableController;
  InformationPlace start;
  InformationPlace destination;
  MapboxNavigation _directions;
  double _distanceRemaining, _durationRemaining;
  final List<_HomeItem> items = List.generate(
    8,
        (i) => _HomeItem(i, 'Luogo n°$i', 'indirizzo', _getIconPointOfInterest(i)),
  );

  @protected
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );

    initPlatformState();

    super.initState();
  }

  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
        ),
      ),
      body: Center(
        child: OrientationBuilder(
          builder: (context, orientation) => _buildList(
              context,
              orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal),
        ),
      ),

    );
  }

  Widget _buildList(BuildContext context, Axis direction) {
    return ListView.builder(
      scrollDirection: direction,
      itemBuilder: (context, index) {
        final Axis slidableDirection =
        direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        var item = items[index];
        return _getSlidableWithLists(context, index, slidableDirection);
      },
      itemCount: items.length,
    );
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
  startNavigation() async {
    Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    start = new InformationPlace("la mia posizione", position.longitude, position.latitude);
    destination = new InformationPlace("Piazza del Ferrarese, Bari",16.871928, 41.1268005);
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

  Widget _getSlidableWithLists(
      BuildContext context, int index, Axis direction) {
    final _HomeItem item = items[index];
    //final int t = index;
    return Slidable(
      key: Key(item.title),
      controller: slidableController,
      direction: direction,

      actionPane: _getActionPane(item.index),
      actionExtentRatio: 0.25,
      child: direction == Axis.horizontal
          ? VerticalListItem(items[index])
          : HorizontalListItem(items[index]),
      actions: <Widget>[

      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Vedi Posizione',
          color: Colors.grey.shade50,
          icon: Icons.location_on,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) =>  PositionOption(),
            ),);
          },
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: 'Avvia Percorso',
          color: Colors.green,
          icon: Icons.map,
          onTap: () {

            startNavigation();
          },
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: 'Invia Feedback',
          color: Colors.amber,
          icon: Icons.feedback,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) =>  FeedBackOption(),
            ),);
          },
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: 'Invia Segnalazione',
          color: Colors.red,
          icon: Icons.not_interested,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) =>  SegnalationOptions(),
            ),);
          },
        ),
      ],
    );
  }



  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }



  static Icon _getIconPointOfInterest(int index) {

       switch(index){
         case 0:
           return Icon(Icons.local_bar,size: 40,color: Colors.amberAccent,);
         case 1:
           return Icon(Icons.local_pharmacy,size: 40,color: Colors.amberAccent,);
         case 2:
           return Icon(Icons.local_grocery_store,size: 40,color: Colors.amberAccent,);
         case 3:
           return Icon(Icons.local_movies,size: 40,color: Colors.amberAccent,);
         case 4:
           return Icon(Icons.local_parking,size: 40,color: Colors.amberAccent,);
         case 5:
           return Icon(Icons.local_pizza,size: 40,color: Colors.amberAccent,);
         case 6:
           return Icon(Icons.local_dining,size: 40,color: Colors.amberAccent,);
         case 7:
           return Icon(Icons.local_laundry_service,size: 40,color: Colors.amberAccent,);
       }

  }

  void _showSnackBar(BuildContext context, String text) {

    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class HorizontalListItem extends StatelessWidget {
  HorizontalListItem(this.item);
  final _HomeItem item;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 160.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: item.icon,
          ),
          Expanded(
            child: Center(
              child: Text(
                item.subtitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item);
  final _HomeItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
          ? Slidable.of(context)?.open()
          : Slidable.of(context)?.close(),
      child: Container(
        color: Colors.white,
        child: ListTile(
          trailing: Icon(Icons.format_align_left),
          leading: item.icon,
          title: Text(item.title),
          subtitle: Text(item.subtitle),
        ),
      ),
    );
  }
}

class _HomeItem {
  const _HomeItem(
      this.index,
      this.title,
      this.subtitle,
      this.icon,
      );

  final int index;
  final String title;
  final String subtitle;
  final Icon icon;

}
