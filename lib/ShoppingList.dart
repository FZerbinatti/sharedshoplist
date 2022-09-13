import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sharedshoplist/Item.dart';
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

  //List<String> listaSpesa = <String>["Latte", "Pane", "Uova", "Tagliato", "Coriandolo", "Bitcoin", "Cipolla", "Garrote", "CikiBriki"];
  List<String> listaSpesa = <String>[];

  List<Item> listaSpesaItems = <Item>[];
  //List<String> listaSpesa = <String>[];

  double height = 200;
  int bought_items_index=-1;
  int added_items_counter =0;
  var  bought_items_indexes = [];
  var ref = "https://sharedshoplist-17901-default-rtdb.europe-west1.firebasedatabase.app" ;




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

        //load listviewspesa

        getShopList(id_spesa_string);

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
                    height: height - 150,

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

                        return  Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            String current_item_name= listaSpesa[index];
                            if (direction==DismissDirection.startToEnd){

                              crossItemFromFirebase(id_spesa, listaSpesa[index]);
                              _onSelected(index);


                            }else{
                              setState(() {
                                removeItemFromFirebase(id_spesa, listaSpesa[index]);
                                listaSpesa.removeAt(index);

                              });
                            }


                            /*// Then show a snackbar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('$item Cancellato, direzione: $direction' )));*/
                          },
                            child: ListTile(

                              title: Text(
                            '$item',
                                  //style: TextStyle(decoration: bought_items_index==index ? TextDecoration.lineThrough : TextDecoration.none)
                                  style: TextStyle(decoration: bought_items_indexes.contains(index) ? TextDecoration.lineThrough : TextDecoration.none)


                            ),
                          )
                        );
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
    //insert item on firebase

    DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL(ref).child("shoplists_ids").child(id_spesa).child(newItemInsertedController.text);
    databaseReference.set("0");


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


  void _onSelected(int index) {
    //log("index: "+index.toString()+"/"+bought_items_indexes.single);
    //log("elemento da crossare:" + bought_items_indexes[index]);
    // what if i cross an already-crossed element?
    if (bought_items_indexes.isEmpty){
      bought_items_indexes.add(listaSpesa.length-1);
    }else{
      /*log("l'elemento è già crossato? " + bought_items_indexes.contains(index).toString());
      if (bought_items_indexes.contains(index)){
        log("l'elemento è già crossato: " );
        //sposto l'elemento in coda e non incremento il counter
        //rimuovo l'elemento dall'index attuale e dall bought items indexes
        bought_items_indexes.removeAt(index);
        //aggiungo l'elemento in coda alla lista e nell'indexes
        bought_items_indexes.add(bought_items_indexes.length);

      }else{
        for(var i = 0; i < bought_items_indexes.length; i++){
          bought_items_indexes[i]= bought_items_indexes[i]-1;
        }
        bought_items_indexes.add(listaSpesa.length-1);
      }*/
      for(var i = 0; i < bought_items_indexes.length; i++){
        bought_items_indexes[i]= bought_items_indexes[i]-1;
      }
      bought_items_indexes.add(listaSpesa.length-1);

      }


    setState(() {
      listaSpesa.add(listaSpesa[index]);
      listaSpesa.removeAt(index);
      bought_items_index = listaSpesa.length-1;
    });
  }

  Future removeItemFromFirebase( String shoplist_id ,String item_name) async{
    log("removing from  "+shoplist_id +" item: "+item_name);
    DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL(ref).child("shoplists_ids").child(shoplist_id).child(item_name);
    databaseReference.remove();

  }

  Future crossItemFromFirebase( String shoplist_id ,String item_name) async{
    log("crossing: " + item_name + " : " +shoplist_id);
    DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL(ref).child("shoplists_ids").child(shoplist_id).child(item_name);
    databaseReference.set("1");

  }


  Future getShopList(String shoplist_id) async{
    log ("getting items from firebase");
    DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL(ref).child("shoplists_ids").child(shoplist_id);
    final snapshot = await databaseReference.get();

    if (snapshot.exists) {
      print(snapshot.value.toString());
      String jsonString = snapshot.value.toString();
      Map? data = snapshot.value as Map?;
      int currentIndex=0;
      data?.forEach((key, value) {
        log( key +" : " + value);
        listaSpesa.add(key);
        if (value=="1"){
          bought_items_indexes.add(currentIndex);
        }
        currentIndex++;

      });

      //listaSpesa.add(snapshot.value.toString());

    } else {
      print('No data available.');
    }
  }


}
