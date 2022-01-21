
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sozluk_uyg_firebase/NotDetaySayfa.dart';
import 'package:sozluk_uyg_firebase/NotKayifSayfa.dart';

import 'Notlar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var refNotlar = FirebaseDatabase.instance.reference().child("notlar");






  Future<bool> uygulamayiKapat() async {
    await exit(0);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [
          IconButton(
              onPressed:(){
                uygulamayiKapat();
              },
              icon: Icon(Icons.exit_to_app))
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Notlar Uygulaması",style: TextStyle(color: Colors.white,fontSize: 16))
            ,
            StreamBuilder<Event>(
                stream: refNotlar.onValue,
                builder: (context,event){
                  if(event.hasData) {
                    var notlarListesi = <Notlar>[];

                    var gelenDegerler = event.data!.snapshot.value;

                    if(gelenDegerler != null){
                      gelenDegerler.forEach((key,nesne){
                        var gelenNot = Notlar.fromJson(key, nesne);
                        notlarListesi.add(gelenNot);
                      });
                    }

                    double ortalama = 0.0;

                    if(!notlarListesi.isEmpty){
                      double toplam = 0.0;

                      for(var n in notlarListesi){
                        toplam = toplam + (n.not1+n.not2)/2;
                      }

                      ortalama = toplam / notlarListesi.length;
                    }

                    return Text("Ortalama : ${ortalama.toInt()}",style: TextStyle(color: Colors.white,fontSize: 14),);
                  }else{
                    return Text("Ortalama : 0",style: TextStyle(color: Colors.white,fontSize: 14),);
                  }
                }
            ),
          ],
        ),
        centerTitle: true,
      ),
            body: WillPopScope(
               onWillPop: uygulamayiKapat,
                    child: StreamBuilder<Event>(
                     stream: refNotlar.onValue,
                     builder: (context,event){
                      if(event.hasData){
                        var notlarListesi = <Notlar>[];

                        var gelenDegerler = event.data!.snapshot.value;

                         if(gelenDegerler != null){
                      gelenDegerler.forEach((key,nesne){
                        var gelenNot = Notlar.fromJson(key, nesne);
                       notlarListesi.add(gelenNot);
                         });
                        }

                     return ListView.builder(
                       itemCount: notlarListesi.length,
                       itemBuilder: (context,indeks){
                       var not = notlarListesi[indeks];
                       return GestureDetector(
                         onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => NotDetaySayfa(not: not,)));
                        },
                         child: Padding(
                           padding: const EdgeInsets.only(left:20.0 , right: 20, top: 6),
                           child: Card(
                             color: Colors.greenAccent,
                              child: SizedBox(
                                height: 60,
                                 child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                     children: [
                                      Container(
                                        alignment: Alignment.center,
                                          height: 60,
                                          width: 100,
                                          child: Text(not.ders_adi,style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),)),
                                      Container(
                                        alignment: Alignment.center,
                                          height: 60,
                                          width: 100,
                                          child: Text(not.not1.toString())),
                                      Container(
                                        alignment: Alignment.center,
                                          height: 60,
                                          width: 100,
                                          child: Text(not.not2.toString())),
                                  ],
                                  ),
                                 ),
                                ),
                         ),
                              );
                              },
                          );
                            }else{
                        return Center();
                      }
                      },
                    ),),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text("Notlar", style: TextStyle(color: Colors.white , fontSize: 30),),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text("Güncelle"),
              leading: Icon(Icons.update, color: Colors.green,),
              onTap: (){


                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
              },
            ),
            ListTile(
              title: Text("Not Ekle"),
              leading: Icon(Icons.add, color: Colors.green,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotKayitSayfa()));
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotKayitSayfa()));
        },
        tooltip: "Not Ekle",
        child: Icon(Icons.add),
      ),

    );
  }
}
