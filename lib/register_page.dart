import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';

/// Email / Şifre ile kayıt sayfası
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rpasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.lightBlueAccent, Colors.blueAccent])),
          child: Center(
            child: Form(
              key: _formKey,
              child: Card(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("Üye Ol",
                            style: GoogleFonts.merriweather(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.blue),
                            )),
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: "Ad Soyad"),
                          validator: (String name) {
                            if (name.trim().isEmpty) {
                              return "Lütfen Ad Soyad giriniz";
                            }
                            return null;
                          },
                        ),
                        //? E-Mail
                        TextFormField(
                          controller: _emailController,
                          decoration:
                              const InputDecoration(labelText: "E-Mail"),
                          validator: (String mail) {
                            if (mail.trim().isEmpty) {
                              return "Lütfen bir mail yazın";
                            }
                            return null;
                          },
                        ),
                        //? Şifre
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: "Şifre"),
                          validator: (String password) {
                            if (password.trim().isEmpty) {
                              return "Lütfen bir şifre yazın";
                            }
                            return null;
                          },
                          obscureText: true, //! Şifrenin görünmesini engeller.
                        ),
                        TextFormField(
                          controller: _rpasswordController,
                          decoration:
                              const InputDecoration(labelText: "Tekrar Şifre"),
                          validator: (String rpassword) {
                            if (rpassword.trim().isEmpty) {
                              return "Lütfen şifreyi tekrar giriniz";
                            }
                            return null;
                          },
                          obscureText: true, //! Şifrenin görünmesini engeller.
                        ),

                        //? Kayıt ol buttonu
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          alignment: Alignment.center,
                          child: SignInButtonBuilder(
                            icon: Icons.person_add,
                            backgroundColor: Colors.blueAccent,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                if (_passwordController.text ==
                                    _rpasswordController.text) {
                                  _register(_nameController);
                                } else {
                                  globalKey.currentState.showSnackBar(SnackBar(
                                      content: Text('Şifreler uyuşmuyor.'),
                                      backgroundColor: Colors.blueAccent));
                                }
                              }
                            },
                            text: "Kayıt ol",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // Widget kapatıldığında controllerları temizle
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register(TextEditingController _nameController) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User user = userCredential.user;

      //firestore a üye ekleme
      String uid = _auth.currentUser.uid;
      print(uid);
      users.add({
        'email': _emailController.text,
        'name': _nameController.text,
        'pass': _passwordController.text,
        'uid': uid
      });

      if (user != null) {
        globalKey.currentState.showSnackBar(SnackBar(
            content: Text("Merhaba ${_nameController.text}"),
            backgroundColor: Colors.blueAccent));
      } else {
        globalKey.currentState.showSnackBar(SnackBar(
            content: Text("Hata Oldu"), backgroundColor: Colors.blueAccent));
      }
    } on FirebaseAuthException catch (er) {
      if (er.message ==
          'The email address is already in use by another account.') {
        globalKey.currentState.showSnackBar(
          SnackBar(
              content: Text(
                  'E-posta adresi zaten başka bir hesap tarafından kullanılıyor.'),
              backgroundColor: Colors.blueAccent),
        );
      } else if (er.message == 'The email address is badly formatted.') {
        globalKey.currentState.showSnackBar(
          SnackBar(
              content: Text('E-posta adresi hatalı biçimde.'),
              backgroundColor: Colors.blueAccent),
        );
      } else if (er.message == 'Password should be at least 6 characters') {
        globalKey.currentState.showSnackBar(
          SnackBar(
              content: Text('Şifre en az 6 karakter olmalıdır.'),
              backgroundColor: Colors.blueAccent),
        );
      } else {
        globalKey.currentState.showSnackBar(SnackBar(
            content: Text('Sistem Hatası.'),
            backgroundColor: Colors.blueAccent));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
