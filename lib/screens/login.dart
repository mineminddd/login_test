import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_test/main.dart';
import 'package:login_test/screens/home.dart';
import 'package:login_test/screens/register.dart';
import 'package:login_test/screens/resetPassword.dart';


class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key}) : super(key: key);

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkAuth(context);
  }

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Sign in", style: TextStyle(color: Colors.white)),
        ),
        body: Container(
            child: Center(
              child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildTextFieldEmail(),
                      buildTextFieldPassword(),
                      buildButtonSignIn(),
                      buildButtonForgotPassword(context),
                      buildOtherLine(),
                      buildButtonGoogle(context),
                      buildButtonRegister(),

                    ],
                  )),
            )));
  }

    Widget buildButtonSignIn() {
    return InkWell(
      child: Container(
          constraints: BoxConstraints.expand(height: 50),
          child: Text("Sign in",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueAccent),
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(12)),
      onTap: () {
        signIn();
      },
    );
  }

    Widget buildOtherLine() {
    return Container(
        child: Row(children: <Widget>[
          Expanded(child: Divider(color: Colors.green[800])),
          Padding(
              padding: EdgeInsets.all(6),
              child: Text("OR",
                  style: TextStyle(color: Colors.black87))),
          Expanded(child: Divider(color: Colors.green[800])),
        ]));
  }
  
  Widget buildButtonGoogle(BuildContext context) {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            child: Text("Login with Google ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.blue[600])),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: Colors.white),
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(12)),
        onTap: () => loginWithGoogle(context));
  }

    Widget buildButtonRegister() {
    return InkWell(
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        child: Text("Sign up",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white)),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black87),
            borderRadius: BorderRadius.circular(20), color: Colors.orange[200]),
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.all(12)),
        onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MySignUpPage()));
      },
    );
  }

  buildButtonForgotPassword(BuildContext context) {
    return InkWell(
        child: Container(
          constraints: BoxConstraints.expand(height: 40),
          child: Text("Forgot password?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87)),
          margin: EdgeInsets.only(top: 12),
        ),
        onTap: () => navigateToResetPasswordPage(context));

  }

  Container buildTextFieldEmail() {
      return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.circular(30)),
          child: TextField(
              controller: emailController,
              decoration: InputDecoration.collapsed(hintText: "Email"),
              style: TextStyle(fontSize: 18)));
    }

    Container buildTextFieldPassword() {
      return Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.circular(30)),
          child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration.collapsed(hintText: "Password"),
              style: TextStyle(fontSize: 18)));
    }

    Future checkAuth(BuildContext context) async {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        print("Already singed-in with");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage(user)));
      }
    }

    Future<FirebaseUser> signIn() async {
      final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ).then((user) {
        print("signed in ${user}");
        checkAuth(context);
      }).catchError((error) {
        print(error.message);
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(error.message, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ));
      });
    }

  Future loginWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount user = await _googleSignIn.signIn();
    GoogleSignInAuthentication userAuth = await user.authentication;

    await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: userAuth.idToken, accessToken: userAuth.accessToken));
    checkAuth(context); // after success route to home.
  }

    navigateToResetPasswordPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyResetPasswordPage()));
  }

}