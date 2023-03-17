import 'package:sozluk_uygulamasi_http_kutuphanesi/Kelimeler.dart';

class KelimelerCevap{
  int success;
  List<Kelimeler> kelimelerListesi;

  KelimelerCevap(this.success, this.kelimelerListesi);

  factory KelimelerCevap.fromJson(Map<String, dynamic> json){
    var jsonArray = json["kelimeler"] as List;
    List<Kelimeler> kelimelerListesi = jsonArray.map((jsonArrayNesnesi) => Kelimeler.fromJson(jsonArrayNesnesi)).toList();
    return KelimelerCevap(json["success"] as int, kelimelerListesi);
  }
}