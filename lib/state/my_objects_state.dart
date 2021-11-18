import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:recollar/models/object.dart';
import 'package:recollar/models/object_simple.dart';

abstract class MyObjectsState extends Equatable{
  final List<ObjectSimple> objects;
  final Object ? object;
  final Uint8List ? imageAR;
  @override
  List<Object> get props =>[];

  const MyObjectsState(this.objects,this.object,this.imageAR);
}
class MyObjectsInitial extends MyObjectsState{

  MyObjectsInitial(): super([],null,null);
}
class MyObjectsOk extends MyObjectsState{
  const MyObjectsOk(List<ObjectSimple> objects): super(objects,null,null);
}
class MyObjectsLoading extends MyObjectsState{

  MyObjectsLoading(List<ObjectSimple> objects): super([],null,null);
}
class MyObjectsSingleOk extends MyObjectsState{

  MyObjectsSingleOk(Object object,List<ObjectSimple> objects): super(objects,object,null);

}
class MyObjectsAddOk extends MyObjectsState{

  const MyObjectsAddOk(List<ObjectSimple> objects): super(objects,null,null);

}
class MyObjectsFormLoading extends MyObjectsState{

  MyObjectsFormLoading(List<ObjectSimple> objects): super(objects,null,null);
}
class MyObjectsGetObjectOk extends MyObjectsState{

  MyObjectsGetObjectOk(Object ? object,List<ObjectSimple> objects): super(objects,object,null);
}
class MyObjectsForm extends MyObjectsState{
  MyObjectsForm(Object ? object): super([],object,null);
}
class MyObjectsRemoveBgLoading extends MyObjectsState{

  MyObjectsRemoveBgLoading(): super([],null,null);
}

class MyObjectsRemoveBgOk extends MyObjectsState{

  MyObjectsRemoveBgOk(Uint8List imageAR,Object ? object): super([],object,imageAR);
}