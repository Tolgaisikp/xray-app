import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xray_app/register_page.dart';

import 'home_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _SignInBody(),
    );
  }
}

class _SignInBody extends StatefulWidget {
  @override
  __SignInBodyState createState() => __SignInBodyState();
}

class __SignInBodyState extends State<_SignInBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.lightBlueAccent, Colors.blueAccent])),
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          //? Email / Şifre
          _EmailPasswordForm(),
        ],
      ),
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  __EmailPasswordFormState createState() => __EmailPasswordFormState();
}

class __EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30.0),
          width: 180,
          height: 180,
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(24.0),
            child: Image(
              fit: BoxFit.contain,
              alignment: Alignment.topRight,
              image: NetworkImage(
                  "https://cdn1.iconfinder.com/data/icons/health-and-care-line-filled-blue/154/Beat_care_health_heart-512.png"),
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Card(
            margin: const EdgeInsets.only(top: 30.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //? Bilgi
                  Container(
                    child: Text("Giriş Yap",
                        style: GoogleFonts.merriweather(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.blue),
                        )),
                    alignment: Alignment.center,
                  ),
                  //? E-Mail
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "E-Mail"),
                    validator: (String mail) {
                      if (mail.trim().isEmpty) return "Lütfen bir mail yazın";
                      return null;
                    },
                  ),
                  //? Şifre
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: "Şifre"),
                    validator: (String password) {
                      if (password.trim().isEmpty)
                        return "Lütfen bir şifre yazın";
                      return null;
                    },
                    obscureText: true, //! Şifrenin görünmesini engeller.
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    alignment: Alignment.center,
                    child: SignInButtonBuilder(
                      icon: Icons.email,
                      backgroundColor: Colors.blueAccent,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _signIn();
                        }
                      },
                      text: "Giriş Yap",
                    ),
                  ),
                  Container(
                    child: SignInButtonBuilder(
                      icon: Icons.person_add,
                      backgroundColor: Colors.blueAccent,
                      text: "Kayıt Ol",
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void _signIn() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      final User user = userCredential.user;
      var _duration = Duration(seconds: 2);
      Timer(_duration, navigation);

      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Hoşgeldin, ${user.email}"),
          backgroundColor: Colors.blueAccent));
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if (e.message == 'The email address is badly formatted.') {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("E-posta adresi hatalı biçimde."),
            backgroundColor: Colors.blueAccent));
      } else if (e.message ==
          'The password is invalid or the user does not have a password.') {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Şifre geçersiz veya kullanıcının şifresi yok."),
            backgroundColor: Colors.blueAccent));
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Sistem hatası."),
            backgroundColor: Colors.blueAccent));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void navigation() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FirebaseAuth.instance.currentUser == null
            ? SignInPage()
            : HomePage(),
      ),
    );
  }
}

class _SignInProvider extends StatefulWidget {
  final String infoText;
  final Buttons buttonType;
  final Function signInMethod;

  const _SignInProvider({
    Key key,
    @required this.infoText,
    @required this.buttonType,
    @required this.signInMethod,
  }) : super(key: key);

  @override
  __SignInProviderState createState() => __SignInProviderState();
}

class __SignInProviderState extends State<_SignInProvider> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                widget.infoText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.center,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              alignment: Alignment.center,
              child: SignInButton(
                widget.buttonType,
                text: widget.infoText,
                onPressed: () async => widget.signInMethod(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
