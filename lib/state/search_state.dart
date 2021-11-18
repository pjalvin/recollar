import 'package:equatable/equatable.dart';
import 'package:recollar/models/object.dart';

abstract class SearchState extends Equatable{
  final List<Object> objects;
  final Object ? object;
  const SearchState(this.objects,this.object);
  @override
  List<Object> get props =>[];

}
class SearchInitial extends SearchState{
  SearchInitial() : super([],null);
}
class SearchPredict extends SearchState{
  final List<String> wordList;
  const SearchPredict(this.wordList,List<Object> objects) : super(objects,null);
}
class SearchPredictLoading extends SearchState{
  const SearchPredictLoading(List<Object> objects) : super(objects,null);

}
class SearchLoading extends SearchState{
  const SearchLoading(List<Object> objects) : super(objects,null);

}
class SearchOk extends SearchState{
  const SearchOk(List<Object> objects):super(objects,null);
}
class SearchObjectOk extends SearchState{
  const SearchObjectOk(List<Object> objects,Object ? object):super(objects,object);
}