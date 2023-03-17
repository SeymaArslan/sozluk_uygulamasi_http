import 'package:flutter/material.dart';
import 'package:sozluk_uygulamasi_http_kutuphanesi/DetaySayfa.dart';
import 'package:sozluk_uygulamasi_http_kutuphanesi/Kelimeler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sozluk_uygulamasi_http_kutuphanesi/KelimelerCevap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Anasayfa(title: 'Flutter Demo Home Page'),
    );
  }
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key, required this.title});



  final String title;

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  List<Kelimeler> parseKelimelerCevap(String cevap){
    return KelimelerCevap.fromJson(json.decode(cevap)).kelimelerListesi;
  }
  
  Future<List<Kelimeler>> tumKelimeleriGoster() async{
    var url = Uri.parse("http://localhost/web-services-sozluk/tum_kelimeler.php");
    var cevap = await http.get(url);
    return parseKelimelerCevap(cevap.body);
  }

  Future<List<Kelimeler>> aramaYap(String aramaKelimesi) async{
    var url = Uri.parse("http://localhost/web-services-sozluk/kelime_ara.php");
    var veri = {"ingilizce": aramaKelimesi};
    var cevap = await http.post(url, body: veri);
    return parseKelimelerCevap(cevap.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu
            ? TextField(
          decoration: InputDecoration(
              hintText: "Arama için bir şey yazın"),
          onChanged: (aramaSonucu){
            print("Arama sonucu : $aramaSonucu");
            setState(() {
              aramaKelimesi = aramaSonucu;
            });
          },
        )
            : Text("SÖZLÜK UYGULAMASI") ,
        actions:[
          aramaYapiliyorMu
              ? IconButton(
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = false;
                aramaKelimesi = "";
              });
            },
            icon: Icon(Icons.cancel),
          )
              : IconButton(
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = true;
              });
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder<List<Kelimeler>>(
        future: aramaYapiliyorMu ? aramaYap(aramaKelimesi) : tumKelimeleriGoster(), // aramaYapılıyorMu false ise normal arayüz görünecek, true ise girdiğimiz harfi içeren kelimeleri göstereecek
        builder: (context, snapshot){
          if(snapshot.hasData){
            var kelimelerListesi = snapshot.data;
            return ListView.builder(
              itemCount: kelimelerListesi!.length,
              itemBuilder: (context,indeks){
                var kelime = kelimelerListesi[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetaySayfa(kelime: kelime)));
                  },
                  child: SizedBox( height: 50,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(kelime.ingilizce, style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(kelime.turkce),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else  {
            return Center();
          }
        },
      ),
    );
  }
}
