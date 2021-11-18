import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recollar/events/my_objects_event.dart';
import 'package:recollar/repositories/my_objects_repository.dart';
import 'package:recollar/state/my_objects_state.dart';


class MyObjectsBloc extends Bloc<MyObjectsEvent,MyObjectsState>{
  final MyObjectsRepository _myObjectsRepository;

  MyObjectsBloc(this._myObjectsRepository):super(MyObjectsInitial());
  @override
  Stream<MyObjectsState> mapEventToState(MyObjectsEvent event) async* {
    if(event is MyObjectsSetCollection){
      _myObjectsRepository.idCollection=event.idCollection;
    }
    if(event is MyObjectsInit){
      yield MyObjectsLoading(_myObjectsRepository.objects);
      await _myObjectsRepository.getObjects(true);
      yield MyObjectsOk(_myObjectsRepository.objects);
    }
    if(event is MyObjectsGetObject){
      yield MyObjectsFormLoading(_myObjectsRepository.objects);
      await _myObjectsRepository.getObjectById(event.idObject);
      yield MyObjectsGetObjectOk(_myObjectsRepository.object,_myObjectsRepository.objects);
    }
    if(event is MyObjectsAdd){
      yield MyObjectsFormLoading(_myObjectsRepository.objects);
      await _myObjectsRepository.addObject(event.objectRequest,event.imageFile,event.imageAR);
      await _myObjectsRepository.getObjects(true);
      yield MyObjectsAddOk(_myObjectsRepository.objects);

    }
    if(event is MyObjectsUpdate){
      yield MyObjectsFormLoading(_myObjectsRepository.objects);
      await _myObjectsRepository.updateObject(event.object,event.imageFile,event.imageAR);
      await _myObjectsRepository.getObjects(true);
      yield MyObjectsAddOk(_myObjectsRepository.objects);

    }
    if(event is MyObjectsDelete){
      yield MyObjectsFormLoading(_myObjectsRepository.objects);
      await _myObjectsRepository.deleteObject(event.idObject);
      await _myObjectsRepository.getObjects(true);
      yield MyObjectsOk(_myObjectsRepository.objects);

    }
    if(event is MyObjectsChangeStatus){
      yield MyObjectsFormLoading(_myObjectsRepository.objects);
      await _myObjectsRepository.changeStatus(event.idObject,event.objectStatus);
      await _myObjectsRepository.getObjects(true);
      yield MyObjectsOk(_myObjectsRepository.objects);
    }
    if(event is MyObjectsChangeTools){
      yield MyObjectsLoading(_myObjectsRepository.objects);
      _myObjectsRepository.objects[event.index].tools=!_myObjectsRepository.objects[event.index].tools;
      yield MyObjectsOk(_myObjectsRepository.objects);
    }
    if(event is MyObjectsInitForm){
      _myObjectsRepository.object=null;
      yield MyObjectsGetObjectOk(_myObjectsRepository.object,_myObjectsRepository.objects);
    }
    if(event is MyObjectsRemoveBgInit){
      yield MyObjectsRemoveBgLoading();
      Uint8List imageAR=await _myObjectsRepository.removeBgImage(event.image);
      yield MyObjectsRemoveBgOk(imageAR,_myObjectsRepository.object);
    }
  }

}