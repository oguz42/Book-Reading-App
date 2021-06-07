import 'package:book_manager/commonWidget/commons.dart';
import 'package:book_manager/pages/homePage.dart';
import 'package:book_manager/services/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FormType { Register, Login }
//Giriş Sayfası

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  CommonWidgets commonWidgets = CommonWidgets();
  AuthServices authServices = AuthServices();

  var _formtype = FormType.Login;
  final _formKey = GlobalKey<FormState>();
  String _email, _sifre;
  String _buttonText, _linkText;
  bool _obscure = true;
  bool _enabled = false;
  bool _enabled1 = false;
  bool _validate = false;
  double height, width;

  Future<void> _formSubmit() async {
    _formKey.currentState.save();
    if (_formtype == FormType.Register) {
      try {
        bool girisBasarilmi = await authServices.register(_email, _sifre);

        if (girisBasarilmi) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(
                  )));

          print(" kayıt olma işlem başarılı");
        }
      } on PlatformException catch (e) {
        debugPrint("Widget oturum acama  hata " + e.code.toString());
        commonWidgets.customToast("User Created Error", Colors.redAccent);
      }
    } else {
      try {
        bool girisBasarilimi = await authServices.signIn(_email, _sifre);
        if (girisBasarilimi) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(
                  )));
        }

        print("oturum acma başarılı");
      } on PlatformException catch (e) {
        commonWidgets.customToast("User Created Error", Colors.redAccent);
      }
    }
  }

  String validatePassword(String _sifre) {
    if ((_sifre.length < 6)) {
      return "En az 6 karakter olmalı";
    }

    return null;
  }

  String validateEmail(String _email) {
    if ((_email.length == 0)) {
      return "Bu alan boş olamaz";
    } else if ((!_email.contains('@'))) {
      return "Geçersiz Email Adresi";
    }

    return null;
  }

  void degistir() {
    setState(() {
      _formtype =
          _formtype == FormType.Login ? FormType.Register : FormType.Login;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _buttonText = _formtype == FormType.Login ? "Sign In" : "Register";
    _linkText = _formtype == FormType.Login
        ? "Don't you have an account? Register"
        : "Do you have an account? Sign In";

    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Stack(
      children: [
        Column(
          children: [
            Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/siginbook.jpg'),
              height: height,
              width: width,
            )
          ],
        ),
        Align(
            child: SingleChildScrollView(
              child: Form(
                autovalidate: _validate,
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 85.0, left: 8),
                      child: Row(
                        children: [
                          Align(
                            child: Text(
                              "Welcome",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 55),
                              textAlign: TextAlign.left,
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:4),
                            child: Align(
                              child: Text(
                                "   Back",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 43),
                                textAlign: TextAlign.left,
                              ),
                              alignment: Alignment.topLeft,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: validateEmail,
                        // initialValue: "ouzsevin@gmail.com",
                        onTap: () {
                          setState(() {
                            _enabled = true;
                            _enabled1 = false;
                          });
                        },
                        onSaved: (String girilenEmail) {
                          _email = girilenEmail;
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          // errorText: _userModel.emailHataMesaji!=null?_userModel.emailHataMesaji:null,

                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(15)),
                          //
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.lightBlueAccent, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: Icon(
                            Icons.mail,
                            color:
                                _enabled == true ? Colors.blue : Colors.white,
                            size: 26,
                          ),
                          hintText: 'Email',
                          labelText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle:
                              TextStyle(fontSize: 18, color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: TextFormField(
                        validator: validatePassword,
                        style: TextStyle(color: Colors.white),
                        //  initialValue: "123456",
                        onTap: () {
                          setState(() {
                            _enabled = false;
                            _enabled1 = true;
                          });
                        },
                        onSaved: (String girilenSifre) {
                          _sifre = girilenSifre;
                        },
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(15)),
                          //bir nevi error border yapıp rengi değiştiriyor
                          // errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          //errorText: _userModel.sifreHataMesaji==null?null:_userModel.sifreHataMesaji,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.lightBlueAccent, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 26,
                            color: _enabled1 == false
                                ? Colors.white
                                : Colors.lightBlueAccent,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                            child: Icon(
                              !_obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: !_obscure ? Colors.blueAccent[700] : Colors.grey[800],
                              size: 26,
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white),

                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 3)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 1,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 6),
                          child: SizedBox(
                            height: 45,
                            child: RaisedButton(
                              color: Colors.blueAccent[700],
                              onPressed: () {
                                _formSubmit();
                                setState(() {
                                  _validate = true;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      _buttonText,
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      onPressed: () => degistir(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        _linkText,
                        style: TextStyle(fontSize: 19,color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            alignment: Alignment.topCenter)
      ],
    ));
  }
}
