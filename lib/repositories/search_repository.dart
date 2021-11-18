import 'package:recollar/models/object.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SearchRepository{
  List<Object> objects=[];
  Object ? object;

  Future<List<String>> predict(String key)async{
    if(key.length<2){
      throw "LLave muy corta";
    }
    var res=await http.get(
      Uri.http("google.com", "/complete/search",{"client":"chrome","q":key}),
    );
    if(res.statusCode!=200){
      throw "No se pudo hacer la predicción";
    }
    else{
      List<String> listWords=[];
      List words=jsonDecode(res.body);
      words[1].forEach((key){
        listWords.add(key);
      });
      return listWords;
    }
  }
  Future<void> getObjects(bool init, String ?key) async {
    print(key);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ?token = prefs.getString("token");
    if (token == null) {
      throw "No existe token Almacenado";
    }
    var res = await http.get(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/object/public",key!=null&&key.isNotEmpty?{"text":key}:{}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print("body :"+res.body);
    if (res.statusCode != 200) {
      throw "No se pudo obtener los objetos";
    }
    else {
      if (init) {
        objects = [];
      }
      var body = json.decode(utf8.decode(res.bodyBytes));
      print("body :"+res.body);
      for (var obj in body) {
        objects.add(Object.fromJson(obj, token));
      }

    }
  }
  Future<void> getObjectById(int idObject)async {
    print("si");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ?token = prefs.getString("token");
    if (token == null) {
      throw "No existe token Almacenado";
    }

    print(idObject);
    var res = await http.get(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/object/$idObject",{"pub":"true"}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    print(res.body);
    print("si");
    if (res.statusCode != 200) {
      throw "No se pudo obtener el objeto";
    }
    else {

      object=Object.fromJson(json.decode(utf8.decode(res.bodyBytes)),token);
    }
  }

}