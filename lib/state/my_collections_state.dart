import 'package:equatable/equatable.dart';
import 'package:recollar/models/category.dart';
import 'package:recollar/models/collection.dart';

abstract class MyCollectionsState extends Equatable{
  final List<Collection> collections;
  final List<Category> category;
  final Collection ?collection;
  @override
  List<Object> get props =>[];

  const MyCollectionsState(this.collections,this.category,this.collection);
}
class MyCollectionsInitial extends MyCollectionsState{

  MyCollectionsInitial(): super([],[],null);
}
class MyCollectionsOk extends MyCollectionsState{
  MyCollectionsOk(List<Collection> collections): super(collections,[],null);
}
class MyCollectionsLoading extends MyCollectionsState{

  MyCollectionsLoading(): super([],[],null);
}
class MyCollectionsLoadingForm extends MyCollectionsState{

  MyCollectionsLoadingForm(): super([],[],null);
}
class MyCollectionsForm extends MyCollectionsState{
  MyCollectionsForm(List<Category> categories,Collection ? collection): super([],categories,collection);
}