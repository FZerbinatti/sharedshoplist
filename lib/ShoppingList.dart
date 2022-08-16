import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'HomePage.dart';
import 'package:flutter/services.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);
  // This widget is the root of your application.



  @override
  State<ShoppingList> createState()=> _ShoppingListState();


}




class _ShoppingListState extends State<ShoppingList> {


  //controller per prendere i dati dai fields
  late TextEditingController newItemInsertedController;
  String id_spesa = "ABC123";
  List<String> listaSpesa = <String>["Latte", "Pane", "Uova"];
  double height = 200;


  @override
  void initState() {
    super.initState();
    _IdRetriever();

    newItemInsertedController = TextEditingController();
  }


  @override
  void dispose() {
    newItemInsertedController.dispose();
  }

  void _IdRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id_spesa_string = prefs.getString('ID_SPESA') ?? '';

    print("preso da sharedpreferences: " + id_spesa_string);

    if (id_spesa_string == null || id_spesa_string.isEmpty) {
      log("id_spesa =  null");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        this.id_spesa = id_spesa_string;
      });
    }
    height = MediaQuery
        .of(context)
        .size
        .height;
    print("Height:");
    print(height);
  }


  @override
  Widget build(BuildContext context) {
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
                          "ID Spesa: ",
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
                              height: 50,

                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
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

                              Clipboard.setData(ClipboardData(text: id_spesa));
                              //show message on screen
                              log("tapped button copy id");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(

                                    content: Text("ID Spesa copiato!",
                                      textAlign: TextAlign.center,),

                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),

            Column(

              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    width: double.infinity,
                    height: height - 140,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),


                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: listaSpesa.length,
                        itemBuilder: (BuildContext context, int index) {
                        final item = listaSpesa[index];

                        return buildListTile(item);
                          /*return Container(
                            height: 60,
                            color: Colors.white,
                            child: Center(
                                child: Text(' ${listaSpesa[index]}')),

                          );*/
                        }
                    ),


                  ),
                ),
              ],
            ),

          ],
          ),
        ),


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await _alertDialogInsertItem();
          if (newItem == null || newItem.isEmpty) return;

          setState(() {
            listaSpesa.insert(listaSpesa.length, newItem);
          });
      },
        backgroundColor: Colors.white,
        elevation: 10,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        foregroundColor: Colors.black,
      ),


    );


  }

  void _clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ID_SPESA', "");
  }



    Future <String?> _alertDialogInsertItem() => showDialog <String> (
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text("Nuovo Item"),
                  elevation: 10,
                  content: TextField(
                    controller: newItemInsertedController,
                    autofocus: true,
                    decoration: InputDecoration(hintText: "Nome Prodotto"),
                    onSubmitted: (_) => insertItem(),
                  ),
                  actions: [
                    TextButton(onPressed: insertItem, child: Text("Inserisci"))
                  ],
                )
        );


  void insertItem() {

    Navigator.of(context).pop(newItemInsertedController.text);

    newItemInsertedController.clear();

  }

  Widget buildListTile(String item)=> ListTile(
    contentPadding: EdgeInsets.symmetric( horizontal: 20, vertical: 5),
    title: Text(
      item,
      style: TextStyle(fontSize: 20),

    ),

    onTap: (){},
  );
}
