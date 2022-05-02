import 'package:flutter/material.dart';
import 'package:loggingoogle/pages/OtherSegnalation.dart';
import 'package:loggingoogle/pages/SearchOption.dart';
import 'package:loggingoogle/pages/SegnalationOption.dart';
import 'package:loggingoogle/pages/UploadPhoto.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'RouteOption.dart';
import 'FeedBackOption.dart';
import 'FeedBackPage.dart';
import 'SegnalationOption.dart';
import 'SegnalationPage.dart';
import '../bloc.navigation_bloc/Route.dart';

class Dashboard extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ('Grid Dashboard UI'),
      initialRoute: '/',
      routes: {
        '/' : (context) => Home(),
        '/FeedBackOption': (context) => FeedBackOption(),
        '/SearchOption': (context) => SearchOption(),
        '/SegnalationOption': (context) => SegnalationOptions(),
        '/FeedBackOption/Success': (context) => Success(),
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Image.asset('android/assets/images/ambrogiohead.png'),
          ),

          SizedBox(
            height: 25,
          ),
          GridDashboard(),
        ],
      ),
    );
  }
}

class GridDashboard extends StatelessWidget {
Items item1 = new Items(
    title: "Percorso",
    img: "android/assets/images/percorso.png");

Items item2 = new Items(
  title: "Ricerca",
  img: "android/assets/images/ricerca.png",
);
Items item3 = new Items(
  title: "Segnala",
  img: "android/assets/images/segnala4.png",
);
Items item4 = new Items(
  title: "Feedback",
  img: "android/assets/images/feedback.png",
);


@override
Widget build(BuildContext context) {
  List<Items> myList = [item1, item2, item3, item4];

  return Stack(

        children: <Widget>[

          Container(
              width: 175,
              height: 175,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20, right: 200, left: 0),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child:GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>  RouteOption(),
                  ),);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      myList[0].img,
                      width: 50,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text( myList[0].title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 8,
                    ),

                    SizedBox(
                      height: 8,
                    ),

                  ],
                ),
              ),
          ),


            Container(
            width: 175,
            height: 175,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 20,left:200 ),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
              child:GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/SearchOption");
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      myList[1].img,
                      width: 50,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text( myList[1].title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 8,
                    ),

                    SizedBox(
                      height: 8,
                    ),

                  ],
                ),
              ),

          ),
          Container(
            width: 175,
            height: 175,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 220, right: 200),

            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child:
            GestureDetector(
              onTap: (){
              Navigator.pushNamed(context, "/SegnalationOption");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    myList[2].img,
                    width: 50,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text( myList[2].title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 8,
                  ),

                  SizedBox(
                    height: 8,
                  ),

                ],
            ),
          ),
          ),


          Container(
            width: 175,
            height: 175,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 220,left: 200),

            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),

            child:GestureDetector(
                onTap: (){
                    Navigator.pushNamed(context,"/FeedBackOption");
                },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    myList[3].img,
                    width: 50,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text( myList[3].title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 8,
                  ),

                  SizedBox(
                    height: 8,
                  ),

                ],
              ),
            ),
          ),
        ],

        );
}
}

class Items {
  String title;
  String img;
  Items({this.title, this.img});
}