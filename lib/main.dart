import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'SplashScreen.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff9C58D2),
      ),
      home: SplashScreen(),
    );
  }
}

class UserDetails {
  final String userName;
  final String photoUrl;
  final  loginStateFB;
  final GoogleSignIn loginStateGoogle;
  bool isInSessionAccountFacebook() {
    return this.loginStateFB != null;
  }
  bool isInSessionAccountGoogle() {
    return this.loginStateGoogle != null;
  }
  UserDetails(this.userName, this.photoUrl,this.loginStateFB,this.loginStateGoogle);
}
/*
class SignIn extends StatefulWidget {
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {

  Map userProfile;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async {

    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign in'),
    ));

    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser userDetails = await _firebaseAuth.signInWithCredential(credential);


    UserDetails details = new UserDetails(
      userDetails.displayName,
      userDetails.photoUrl,
      null,
      _googlSignIn
    );
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new SideBarLayout(detailsUser: details),
      ),
    );
    return userDetails;
  }


  _loginWithEmail(){

    UserDetails user = new UserDetails("Utente","https://img.icons8.com/cotton/64/000000/user-male--v1.png",null,null);
    Route route = new MaterialPageRoute(
      builder: (context) =>  new SideBarLayout( detailsUser: user),
    );
    Navigator.push(context,route);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset('android/assets/images/ambrogio.png'),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height:10.0),
                Container(
                    width: 250.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Color(0xffffffff),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.google,color: Color(0xffCE107C)),
                            SizedBox(width:10.0),
                            Text(
                              'Accedi con Google',
                              style: TextStyle(color: Colors.black,fontSize: 18.0),
                            ),
                          ],),
                        onPressed: () => _signIn(context)
                            .then((FirebaseUser user) => print(user))
                            .catchError((e) => print(e)),
                      ),
                    )
                ),

                Container(
                    width: 250.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Color(0xffffffff),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.solidEnvelope,color: Color(0xff4caf50),),
                            SizedBox(width:10.0),
                            Text(
                              "Accedi con E-mail",
                              style: TextStyle(color: Colors.black,fontSize: 18.0),
                            ),
                          ],),
                        onPressed: () {
                          _loginWithEmail();
                        },
                      ),
                    )
                ),
              ],
            ),
          ],
        ),),
    );
  }
}
*/







