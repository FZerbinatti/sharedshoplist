import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);
  // This widget is the root of your application.



  @override
  State<ShoppingList> createState()=> _ShoppingListState();


}




class _ShoppingListState extends State<ShoppingList> {



  //controller per prendere i dati dai fields
  final _idController = TextEditingController();
  String id_spesa ="ABC123";

  void _incrementCounter() {
    setState(() {

    });
  }






    @override
    Widget build(BuildContext context){

      //_IdRetriever();
      //_clearSharedPreferences();
      log("init");
      return Scaffold(
        //qui va tutta la UI dell'app
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
              child: Column(children: [
                SizedBox(height: 20),

                Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    //container specs
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Identificativo Spesa: ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: InkWell(
                                child: Container(

                                  width: 170,
                                  height: 50.0,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                          "$id_spesa",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Icon(Icons.copy)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  //show message on screen
                                  log("tapped button copy id");
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(

                                    content: Text("ID Spesa copiato!",textAlign: TextAlign.center,),

                                  ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
             ),
            ),

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          backgroundColor: Colors.white,
          tooltip: 'Increment',
          child: const Icon(Icons.add), foregroundColor: Colors.black,
        ),
      );
  }




  void _IdRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id_spesa_string = prefs.getString('ID_SPESA') ?? '';

    print("preso da sharedpreferences: " +id_spesa_string);

    if (id_spesa_string == null||id_spesa_string.isEmpty){
      log("id_spesa =  null");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }else{
      log("id_spesa = NOT null");
      this.id_spesa = id_spesa_string;

      print("ID SPESA:"+id_spesa_string);
      updateState();
      //idSpesaController.text = id_spesa;

    }
  }

  void updateState(){
      setState(() {
        this.id_spesa=id_spesa;
      });
  }

  void _clearSharedPreferences() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('ID_SPESA', "");
  }
}

