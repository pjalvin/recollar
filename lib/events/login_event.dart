import 'package:equatable/equatable.dart';
import 'package:recollar/models/user.dart';
import 'package:recollar/models/user_auth.dart';

abstract class LoginEvent extends Equatable{
  @override
  List<Object> get props =>[];

}
class LoginVerify extends LoginEvent{
  LoginVerify();
}
class LoginClick extends LoginEvent{
  final UserAuth userAuth;
  LoginClick(this.userAuth);
}
class SignupClick extends LoginEvent{
  final User user;
  SignupClick(this.user);
}
class SignupChangePage extends LoginEvent{
  SignupChangePage();
}
class LoginChangePage extends LoginEvent{
  LoginChangePage();
}
class SignOut extends LoginEvent{
  SignOut();
}