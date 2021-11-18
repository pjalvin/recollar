import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recollar/events/login_event.dart';
import 'package:recollar/models/user.dart';
import 'package:recollar/models/user_auth.dart';
import 'package:recollar/repositories/login_repository.dart';
import 'package:recollar/state/login_state.dart';
import 'package:recollar/util/toast_lib.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  LoginRepository loginRepository;

  LoginBloc(this.loginRepository):super(LoginInitial());
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is LoginVerify){
      try{
        yield LoginInitial();
        User user=await loginRepository.profile();
        yield LoginOk(UserAuth("",""), user);
      }
      catch (e){
        ToastLib.error(e.toString());
        yield LoginPage(UserAuth("",""));

      }
    }
    if(event is LoginClick){
      try{
        yield LoginLoading();
        await loginRepository.login(event.userAuth);
        User user=await loginRepository.profile();
        yield LoginOk(UserAuth("",""), user);
      }
      on SocketException catch(e){
        print(e.toString());
        ToastLib.error("No se puede conectar con el servidor");
        yield LoginFailed(event.userAuth);

      }
      catch(e){
        ToastLib.error(e.toString());
        yield LoginFailed(event.userAuth);
      }
    }
    else if (event is SignupClick){
      try{
        yield SignupLoading();
        await loginRepository.signup(event.user);
        UserAuth userAuth=UserAuth("", event.user.email);
        yield LoginPage(userAuth);
      }
      on SocketException catch(_){
        ToastLib.error("No se puede conectar con el servidor");
        yield SignupPage();

      }
      catch(e){
        ToastLib.error(e.toString());
        yield SignupPage();
      }

    }
    else if(event is SignupChangePage){
      yield SignupPage();
    }
    else if(event is LoginChangePage){
      yield LoginPage(UserAuth("",""));
    }
    else if(event is SignOut){
      await loginRepository.signOut();
      yield LoginPage(UserAuth("",""));
    }

  }

}