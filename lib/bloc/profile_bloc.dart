import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recollar/events/login_event.dart';
import 'package:recollar/events/profile_event.dart';
import 'package:recollar/models/user.dart';
import 'package:recollar/models/user_auth.dart';
import 'package:recollar/repositories/login_repository.dart';
import 'package:recollar/repositories/profile_repository.dart';
import 'package:recollar/state/login_state.dart';
import 'package:recollar/state/profile_state.dart';
import 'package:recollar/util/toast_lib.dart';

class ProfileBloc extends Bloc<ProfileEvent,ProfileState>{
  final ProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository):super(ProfileInitial());
  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if(event is ProfileInit){
      try{
        yield ProfileLoading();
        await _profileRepository.profile();
        yield ProfileOk( _profileRepository.user,_profileRepository.lock);
      }
      catch (e){

        yield ProfileLoading();
      }
    }
    if(event is ProfileChange){
      try{
        yield ProfileLoading();
        await _profileRepository.updateProfile(event.profileRequest);
        ToastLib.ok("Datos modificados correctamente");
        yield ProfileOk( _profileRepository.user,_profileRepository.lock);
      }
      catch (e){
        ToastLib.error(e.toString());
        yield ProfileOk( _profileRepository.user,_profileRepository.lock);
      }
    }
    if(event is PasswordChange){
      try{
        yield ProfileLoading();
        await _profileRepository.changePassword(event.userChangeRequest);
        ToastLib.ok("Contraseña modificada correctamente");
        yield ProfileOk( _profileRepository.user,_profileRepository.lock);
      }
      catch (e){
        ToastLib.error(e.toString());
        yield ProfileOk( _profileRepository.user,_profileRepository.lock);
      }
    }
    if(event is LockChange){
      try{
        yield ProfileLoading();
        await _profileRepository.changeFingerLock();
        if(_profileRepository.lock){
          ToastLib.ok("Se habilito la seguridad.");
        }
        else{
          ToastLib.ok("Se deshabilito la seguridad.");

        }
        yield ProfileOk( _profileRepository.user,_profileRepository.lock);
      }
      catch (e){
        ToastLib.error(e.toString());
        yield ProfileOk( _profileRepository.user,_profileRepository.lock);
      }
    }
  }

}