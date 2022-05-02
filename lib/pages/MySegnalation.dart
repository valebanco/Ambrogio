import 'package:loggingoogle/pages/SegnalationDetails.dart';
import 'SegnalationOption.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:loggingoogle/pages/FeedBackOption.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class MySegnalation extends StatelessWidget with NavigationStates{
  @override
  build (BuildContext context){
    return MySegnalationS();
  }
}
class MySegnalationS extends StatefulWidget{
  MySegnalationState createState() => MySegnalationState();
}

class MySegnalationState  extends State<MySegnalationS>{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new ListPage(),
    );

  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: topAppBar(context),
      body: makeBody(context),
      floatingActionButton: makeAddFeedback(context),

    );
  }
}

Widget makeAddFeedback (BuildContext context) {
  return FloatingActionButton.extended(
    backgroundColor: Colors.blue[400],
    onPressed: () {
      Navigator.push(context,MaterialPageRoute(builder: (context) => SegnalationOptions()));
    },
    icon: Icon(Icons.add),
    label: Text("Aggiungi Segnalazione"),
  );

}
Widget topAppBar(BuildContext context) {
  return
    PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child:AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Image.asset("android/assets/images/ambrogiohead.png",height: 70,),
        )
    );
}


double rating = 0;



Widget makeBody(BuildContext context) {
  return
    Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(index,context);
        },
    ),
  );
}


Widget makeCard(int index,BuildContext context){
  final Icon iconBarrer = Icon (Icons.block,color: Colors.red, size: 40);
  final String DescriptionB = "presenza di barriera";
  Card result;
  switch (index){
    case 0:
      result = buildCard(iconBarrer,DescriptionB,context);
      break;
    case 1:
      result = buildCard(iconBarrer,DescriptionB,context);
      break;
    case 2:
      result = buildCard(iconBarrer,DescriptionB, context);
      break;
    case 3:
      result = buildCard(iconBarrer,DescriptionB,context);
      break;
    case 4:
      result = buildCard(iconBarrer,DescriptionB,context);
      break;
    case 5:
      result = buildCard(iconBarrer,DescriptionB,context);
      break;

  }

  return result;
}

Widget buildCard(Icon icon, String state, BuildContext context) {
  return Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Colors.blue),
      child: makeListTile(icon,state,context),
    ),
  );
}

Widget makeListTile(Icon icon, String state, BuildContext context) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      //child: Icon(Icons.autorenew, color: Colors.white),
      child: icon,
    ),
    trailing: IconButton(
      onPressed: () {
        Navigator.push(context,MaterialPageRoute(builder: (context) => SegnalationDetails()),);
      },
      icon: Icon(Icons.arrow_forward,color: Colors.white)),
    title: Text("Nome Segnalazione",
      style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Wrap(
      direction: Axis.vertical,
      children: <Widget>[
        Text("Indirizzo", style: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold, fontSize: 15),),
        Text(state, style:  TextStyle(color: Colors.white , fontSize: 15),)
      ],
    ),

  );
}
