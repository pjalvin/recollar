import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recollar/events/my_collections_event.dart';
import 'package:recollar/repositories/my_collections_repository.dart';
import 'package:recollar/state/my_collections_state.dart';
import 'package:recollar/util/toast_lib.dart';


class MyCollectionsBloc extends Bloc<MyCollectionsEvent,MyCollectionsState>{
  final MyCollectionsRepository _myCollectionsRepository;

  MyCollectionsBloc(this._myCollectionsRepository):super(MyCollectionsInitial());
  @override
  Stream<MyCollectionsState> mapEventToState(MyCollectionsEvent event) async* {
    if(event is MyCollectionsInit){
      yield MyCollectionsLoading();
      await _myCollectionsRepository.getCollections(init: true);
      yield MyCollectionsOk(_myCollectionsRepository.collections);
    }
    if(event is MyCollectionsInitForm){
      yield MyCollectionsLoadingForm();
      await _myCollectionsRepository.getCategories();
      var categories=_myCollectionsRepository.categories;
      yield MyCollectionsForm(categories, event.collection);
    }
    if(event is MyCollectionsAdd){
      yield MyCollectionsLoading();
      await _myCollectionsRepository.addCollection(event.collectionRequest,event.imageFile);
      await _myCollectionsRepository.getCollections(init: true);
      yield MyCollectionsOk(_myCollectionsRepository.collections);

    }
    if(event is MyCollectionsUpdate){
      yield MyCollectionsLoading();
      await _myCollectionsRepository.updateCollection(event.collectionRequest,event.imageFile);
      await _myCollectionsRepository.getCollections(init: true);
      ToastLib.ok("Se modificó la coleccion");
      yield MyCollectionsOk(_myCollectionsRepository.collections);

    }
    if(event is MyCollectionsDelete){
      yield MyCollectionsLoadingForm();
      await _myCollectionsRepository.deleteCollection(event.idCollection);
      await _myCollectionsRepository.getCollections(init: true);
      yield MyCollectionsOk(_myCollectionsRepository.collections);

    }
    if(event is MyCollectionsChangeTools){
      yield MyCollectionsLoading();
      _myCollectionsRepository.collections[event.index].tools=!_myCollectionsRepository.collections[event.index].tools;
      yield MyCollectionsOk(_myCollectionsRepository.collections);
    }
  }

}