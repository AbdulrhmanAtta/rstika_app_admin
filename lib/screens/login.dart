import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rstikaadminapp/screens/admin.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  static const String id = 'login';
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent.shade400,
          title: Text('Login Screen App'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Restika Restaurant Admin',
                      style: TextStyle(
                          color: Colors.redAccent.shade400,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged:(value){
                      email = value;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value){
                      password = value;
                    },
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    //forgot password screen
                  },
                  textColor: Colors.red.shade300,
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.redAccent.shade400,
                      child: Text('Login'),
                      onPressed: () async {
                        try{
                      final newUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
                       if(newUser != null){
                          print(email);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Admin(email: email),));
          
                       } 
                        }catch(e) {
                          print(e);

                        }
                        
                      },
                    )),
                Container(
                    child: Row(
                      children: <Widget>[
                        // Text('Does not have account?'),
                        // FlatButton(
                        //   textColor: Colors.blue,
                        //   child: Text(
                        //     'Sign in',
                        //     style: TextStyle(fontSize: 20),
                        //   ),
                        //   onPressed: () {
                        //     //signup screen
                        //   },
                        // )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
  }
}