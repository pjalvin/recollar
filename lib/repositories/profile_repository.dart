import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:recollar/models/profile_request.dart';
import 'package:recollar/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recollar/models/password_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileRepository{
  User user=User("","","",0,"");
  bool lock=false;

  Future<void> profile()async{
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
      throw "No se pudo obtener el perfil del usuario";
    }
    else{
      user=User.fromJson(jsonDecode(res.body));

      bool? finger= prefs.getBool("finger");
      lock=finger??false;
    }
  }
  changeFingerLock()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    bool? finger= prefs.getBool("finger");
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics =
    await auth.canCheckBiometrics;
    if(canCheckBiometrics){
      bool authenticated = await auth.authenticate(
          localizedReason:
          'Seguridad de Inicio de Sesión',
          useErrorDialogs: true,
          androidAuthStrings: const AndroidAuthMessages(biometricHint: "",signInTitle: "RecollAr",cancelButton: "Cancelar",biometricRequiredTitle: "",),
          stickyAuth: true,

          biometricOnly: true);
      if(authenticated){
        if(finger==true){
          await prefs.setBool("finger", false);
          lock=false;
        }
        else{
          await prefs.setBool("finger", true);
          lock=true;
        }
        }
      else{
        throw "Se cancelo la operacion de habilitacion de seguridad";
      }
      }
      else{
        throw "Dispositivo no soportado";
      }
  }
  Future<void> updateProfile(ProfileRequest profileRequest)async{
    profileRequest.verifyData();
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.put(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/user"),
      body: jsonEncode(profileRequest.toJson()),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if(res.statusCode!=200){
      throw "No se pudo modificar el usuario";
    }
    else{
    user.firstName=profileRequest.firstName;
    user.lastName=profileRequest.lastName;
    user.phoneNumber=profileRequest.phoneNumber;}
  }
  Future<void> changePassword(PasswordRequest userChangeRequest)async{
    userChangeRequest.verifyData();
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.put(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/user/password"),
      body: jsonEncode(userChangeRequest.toJson()),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if(res.statusCode!=200){
      throw "No se pudo modificar la contraseña";
    }
  }

}