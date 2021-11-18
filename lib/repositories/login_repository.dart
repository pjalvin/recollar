import 'package:recollar/models/user.dart';
import 'package:recollar/models/user_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
class LoginRepository{

  Future login(UserAuth userAuth) async{
    userAuth.verifyData();
    print(userAuth.toJson());
      var res=await http.post(
          Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/login"),
          body: userAuth.toJson(),

          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": dotenv.env['API_TOKEN'] ?? ""
          },
          encoding: Encoding.getByName("utf-8")
      );
      if(res.statusCode!=200){
        throw "Correo electrónico o contraseña incorrectos";
      }
      var body=jsonDecode(res.body);
      SharedPreferences prefs=await SharedPreferences.getInstance();
      await prefs.setString("token", body["access_token"] ?? "");
      await prefs.setBool("finger", false);

  }

  Future signup(User user) async{
    user.verifyData();
    var res=await http.post(
        Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/user/signup"),
        body: jsonEncode(user.toJson()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": dotenv.env['API_TOKEN'] ?? ""
        },
    );
    print(res.body);
    if(res.statusCode!=200){
      throw "No se pudo registrar al usuario";
    }

  }

  Future<User> profile()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.get(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/user"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if(res.statusCode!=200){
      print(res.body);
      throw "No se pudo obtener el perfil del usuario";
    }
    else{
      var user=User.fromJson(jsonDecode(res.body));
      bool? finger= prefs.getBool("finger");
      if(finger==true){

        final LocalAuthentication auth = LocalAuthentication();
        bool canCheckBiometrics =
        await auth.canCheckBiometrics;
        if(canCheckBiometrics){
          bool authenticated = await auth.authenticate(
              localizedReason:
              'Scan your fingerprint',
              useErrorDialogs: true,
              stickyAuth: true,
              biometricOnly: true);
          if(authenticated){
            return user;
          }
          else{
            throw "No se pudo realizar la verificación de huella ingrese sus credenciales o reinicie la aplicación";
          }
        }
      }
      return user;
    }
  }

  signOut()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.remove("token");
  }

}