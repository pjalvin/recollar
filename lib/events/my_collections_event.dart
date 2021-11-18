import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recollar/models/collection.dart';
import 'package:recollar/models/collection_request.dart';


abstract class MyCollectionsEvent extends Equatable{
  @override
  List<Object> get props =>[];

}
class MyCollectionsInit extends MyCollectionsEvent{

  MyCollectionsInit();
}
class MyCollectionsInitForm extends MyCollectionsEvent{
  final Collection ? collection;
  MyCollectionsInitForm(this.collection);
}
class MyCollectionsAdd extends MyCollectionsEvent{
  final CollectionRequest collectionRequest;
  final XFile imageFile;
  MyCollectionsAdd(this.collectionRequest,this.imageFile);
}

class MyCollectionsUpdate extends MyCollectionsEvent{
  final CollectionRequest collectionRequest;
  final XFile ? imageFile;
  MyCollectionsUpdate(this.collectionRequest,this.imageFile);
}

class MyCollectionsDelete extends MyCollectionsEvent{
  final int idCollection;
  MyCollectionsDelete(this.idCollection);
}
class MyCollectionsChangeTools extends MyCollectionsEvent{
  final int index;
  MyCollectionsChangeTools(this.index);
}