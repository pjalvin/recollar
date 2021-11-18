import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recollar/events/search_event.dart';
import 'package:recollar/repositories/search_repository.dart';
import 'package:recollar/state/search_state.dart';


class SearchBloc extends Bloc<SearchEvent,SearchState>{
  final SearchRepository _searchRepository;

  SearchBloc(this._searchRepository):super(SearchInitial());
  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if(event is SearchInitPredict){
      try{
        yield SearchPredictLoading(_searchRepository.objects);
        List<String> words=await _searchRepository.predict(event.key);
        yield SearchPredict(words,_searchRepository.objects);
      }
      catch(e){
        yield SearchPredictLoading(_searchRepository.objects);
      }
    }
    if(event is SearchInit){
      try{
        yield SearchLoading(_searchRepository.objects);
        await _searchRepository.getObjects(true,null);
        yield SearchOk(_searchRepository.objects);
      }
      catch(e){
        print(e);
        yield SearchPredictLoading(_searchRepository.objects);
      }
    }
    if(event is SearchObjectInit){
      try{
        yield SearchLoading(_searchRepository.objects);
        await _searchRepository.getObjectById(event.idObject);
        yield SearchObjectOk(_searchRepository.objects,_searchRepository.object);
      }
      catch(e){
        print(e);
        yield SearchPredictLoading(_searchRepository.objects);
      }
    }
    if(event is SearchInitSearch){
      try{
        yield SearchLoading(_searchRepository.objects);
        await _searchRepository.getObjects(true,event.key);
        yield SearchOk(_searchRepository.objects);
      }
      catch(e){
        print(e);
        yield SearchPredictLoading(_searchRepository.objects);
      }
    }
  }

}