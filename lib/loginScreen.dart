import 'package:flutter/material.dart';
import 'main.dart';
import 'sidebar/sidebar_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
  static _loginWithEmail(BuildContext context){

    UserDetails user = new UserDetails("Utente","https://img.icons8.com/cotton/64/000000/user-male--v1.png",null,null);
    Route route = new MaterialPageRoute(
      builder: (context) =>  new SideBarLayout( detailsUser: user),
    );
    Navigator.push(context,route);

  }
  loginWithGoogle(BuildContext context) {
    return  Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            FontAwesomeIcons.google, color: Colors.red[700], size: 35,),
          onPressed: () =>
              _signIn(context)
                  .then((FirebaseUser user) => print(user))
                  .catchError((e) => print(e)),
        )
    );
  }
  final logo = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48.0,
      child: Image.asset('android/assets/images/ambrogiohead.png'),
    ),
  );


  final email = TextFormField(
    keyboardType: TextInputType.emailAddress,
    autofocus: false,
    initialValue: 'Utente@esempio.com',
    decoration: InputDecoration(
      hintText: 'Email',
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    ),
  );

  final password = TextFormField(
    autofocus: false,
    initialValue: 'some password',
    obscureText: true,
    decoration: InputDecoration(
      hintText: 'Password',
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    ),
  );

  loginButton(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _loginWithEmail(context);

        },
        padding: EdgeInsets.all(12),
        color: Colors.blue[900],
        child: Text('Accedi', style: TextStyle(color: Colors.white,fontSize: 20)),
      ),
    );
  }

  final LabelOr = FlatButton(
    child: Text(
      '- O Accedi con -',
      style: TextStyle(color: Colors.black54),
    ),
    onPressed: () {},
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Builder(
            builder: (context) => ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton(context),
                LabelOr,
                loginWithGoogle(context),
              ],
            ),
        )

      ),
    );

  }
}