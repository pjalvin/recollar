import 'package:equatable/equatable.dart';
import 'package:recollar/models/user.dart';

abstract class ProfileState extends Equatable{
  final User user;
  final bool lock;
  const ProfileState(this.user,this.lock);
  @override
  List<Object> get props =>[user,lock];

}
class ProfileInitial extends ProfileState{
  ProfileInitial() : super(User("","","",0,""),false);
}
class ProfileOk extends ProfileState{
  const ProfileOk(User user,bool lock) : super(user,lock);
}
class ProfileLoading extends ProfileState{
  ProfileLoading() : super(User("","","",0,""),false);

}