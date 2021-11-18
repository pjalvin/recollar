import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recollar/models/object.dart';
import 'package:recollar/models/object_request.dart';


abstract class MyObjectsEvent extends Equatable{
  @override
  List<Object> get props =>[];

}
class MyObjectsInit extends MyObjectsEvent{
  MyObjectsInit();
}
class MyObjectsSetCollection extends MyObjectsEvent{
  int idCollection;
  MyObjectsSetCollection(this.idCollection);
}
class MyObjectsGetObject extends MyObjectsEvent{
  int idObject;
  MyObjectsGetObject(this.idObject);
}
class MyObjectsChangeTools extends MyObjectsEvent{
  final int index;
  MyObjectsChangeTools(this.index);
}
class MyObjectsInitForm extends MyObjectsEvent{
  MyObjectsInitForm();
}
class MyObjectsAdd extends MyObjectsEvent{
  final ObjectRequest objectRequest;
  final XFile ?imageFile;
  final Uint8List ?imageAR;
  MyObjectsAdd(this.objectRequest,this.imageFile,this.imageAR);
}
class MyObjectsUpdate extends MyObjectsEvent{
  final ObjectRequest object;
  final XFile ?imageFile;
  final Uint8List ?imageAR;
  MyObjectsUpdate(this.object, this.imageFile,this.imageAR);
}
class MyObjectsDelete extends MyObjectsEvent{
  final int idObject;
  MyObjectsDelete(this.idObject);
}
class MyObjectsChangeStatus extends MyObjectsEvent{
  final int idObject;
  final int objectStatus;
  MyObjectsChangeStatus(this.idObject,this.objectStatus);
}
class MyObjectsRemoveBgInit extends MyObjectsEvent
{
  final XFile image;
  MyObjectsRemoveBgInit(this.image);
}
