import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import 'ShoppingList.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  State<HomePage> createState()=> _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      //qui va tutta la UI dell'app
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            Padding(

              padding: const EdgeInsets.symmetric(horizontal: 8.0),

               child: OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(300, 60),
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                      primary: Colors.white,
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // <-- Radius
                      ),
                    ),
                    onPressed: () {
                      //generate a casual 10 digit code, save it on shared preferences and load next activity

                      const _chars = 'QWERTYUIOPASDFGHJKLZXCVBNM1234567890';
                      Random _rnd = Random();

                      String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
                          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

                       String id_spesa = (getRandomString(10));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(

                        content: Text("ID Spesa generato: $id_spesa",textAlign: TextAlign.center,),

                      ));
                      
                      
                      
                      //save id_spesa on sharedpreferences

                      _IdSaver(id_spesa);
                      //then navigate on the list page


                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ShoppingList()),
                      );

                    },
                    child: Text('Nuova Lista'),

                ),


            ),SizedBox(height: 60),

            Padding(

              padding: const EdgeInsets.symmetric(horizontal: 8.0),

              child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 60),
                  textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                  primary: Colors.white,
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // <-- Radius
                  ),
                ),
                onPressed: () {
                  // open alert dialog to insert the code, save the code on shared preferences and load next activity
                },
                child: Text('Aggiungi lista esistente'),

              ),


            )




          ],
          ),
        ),
      ),

    );
  }

  void _IdSaver(String id) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('ID_SPESA', id);
    // crea su firebase un oggetto con questo ID
  }


}

