import 'package:flutter/material.dart';
import 'package:loggingoogle/pages/FeedBackOption.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
class MyFeedBack extends StatelessWidget with NavigationStates{
  @override
  build (BuildContext context){
    return MyFeedbackS();
  }
}
class MyFeedbackS extends StatefulWidget{
  MyFeedbackState createState() => MyFeedbackState();
}

class MyFeedbackState  extends State<MyFeedbackS>{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
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
      body: makeBody,
      floatingActionButton: makeAddFeedback(context),

    );
  }
}

Widget makeAddFeedback (BuildContext context) {
  return FloatingActionButton.extended(
    backgroundColor: Colors.blue[400],
    onPressed: () {
      Navigator.push(context,MaterialPageRoute(builder: (context) => FeedBackOption()),);
    },
    icon: Icon(Icons.add),
    label: Text("Aggiungi Feedback"),
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



final makeBody = Container(
  child: ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: 6,
    itemBuilder: (BuildContext context, int index) {
      return makeCard(index,context);
    },
  ),
);


Widget makeCard(int index,BuildContext context){
  Card result;
  switch (index){
      case 0:
        result = buildCard(Icon(Icons.local_bar,size: 40,color: Colors.amberAccent,),context);
      break;
      case 1:
        result = buildCard(Icon(Icons.local_cafe,size: 40,color: Colors.amberAccent,),context);
      break;
      case 2:
        result = buildCard(Icon(Icons.local_dining,size: 40,color: Colors.amberAccent,),context);
      break;
      case 3:
        result = buildCard(Icon(Icons.local_hotel,size: 40,color: Colors.amberAccent,),context);
      break;
      case 4:
        result = buildCard(Icon(Icons.local_pizza,size: 40,color: Colors.amberAccent,),context);
      break;
      case 5:
        result = buildCard(Icon(Icons.local_movies,size: 40,color: Colors.amberAccent,),context);
      break;

  }

  return result;
}

Widget buildCard(Icon icon,BuildContext context) {
  return Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Colors.blue),
      child: makeListTile(icon,context),
    ),
  );
}

alertDeleteFeedback(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(

        title:
        Row(
          children: <Widget>[
            Text("ATTENZIONE"),
            Icon(Icons.warning,color: Colors.yellow[700],),
            Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(left: 90,bottom: 90),
                child:IconButton(
                    icon: Icon(Icons.close,color: Colors.grey,),
                    onPressed: (){
                      Navigator.of(context).pop();
                    }
                )
            ),
          ],
        ),
        content: new Text("Vuoi veramente eliminare il Feedback?"),
        actions: <Widget>[
          FlatButton(
              child: Text('Sì'),
              color: Colors.red,
              onPressed: () {
                Navigator.pop(context);


              }
          ),
          FlatButton(
            child: Text('No'),
            color: Colors.green,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
  );
}
Widget makeListTile(Icon icon,BuildContext context) {

  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    trailing: IconButton(
      icon: Icon(Icons.delete,color: Colors.red,),
      onPressed: (){
        alertDeleteFeedback(context);
      },
    ),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      //child: Icon(Icons.autorenew, color: Colors.white),
      child: icon,
    ),
    title: Text("Nome del punto di interesse",
      style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Row(
      children: <Widget>[
        Text(" Indirizzo località", style: TextStyle(color: Colors.white , fontSize: 15)
        ),
        SmoothStarRating(
          rating: rating,
          size: 20,
          starCount: 5,
          color: Colors.yellow,)
      ],
    ),

  );
}











