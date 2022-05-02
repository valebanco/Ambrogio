import 'package:flutter/material.dart';
import'UploadPhoto.dart';
import 'homepage.dart';
class OtherSegnalation extends StatelessWidget{
  Widget iconBack(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.zero,
      child: IconButton(icon: Icon(Icons.arrow_back_ios),color: Colors.blue,
      onPressed: (){
        Navigator.pop(context);
      },),
    );
  }
  Widget logo() {
    return Container(
      height: 150,
      color: Colors.transparent,
      child: Image.asset("android/assets/images/ambrogioContorno.png"),
    );
  }
  Widget textComment(){
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      alignment: Alignment.topCenter,
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
          icon: Icon(Icons.comment),
          labelText: "Descrivi la tua segnalazione",
        ),
      ),

    );
  }
  Widget buttonDone(BuildContext context){
    return GestureDetector(
      child:
            RaisedButton(
              padding:  EdgeInsets.all(0),
              child: Container(
                  width: 150,
                  height: 40,
                  decoration:  BoxDecoration(
                    border: Border(
                        top:BorderSide(style: BorderStyle.none,width: 0.0),
                        bottom:BorderSide(style: BorderStyle.none,width: 0.0),
                        left:BorderSide(style: BorderStyle.none,width: 0.0),
                        right:BorderSide(style: BorderStyle.none,width: 0.0)),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,

                  ),
                  child:
                  Row(children: <Widget>[
                    Text("       Avanti", style: TextStyle(decoration: TextDecoration.none,
                        color: Colors.blue,
                        fontSize: 20),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.blue[900],),
                  ],
                  )
              ),
              shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.blue)
              ),
            ),


        onTap: (){
          Navigator.push(context, MaterialPageRoute(
          builder: (context)=> UploadPhoto()));
      },
    );

  }
  @override
  Widget build(BuildContext context) {
    return
    Column(
      children: <Widget>[
        iconBack(context),
        logo(),
        textComment(),
        buttonDone(context),
      ],
    );

  }

}