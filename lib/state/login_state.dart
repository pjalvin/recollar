import 'package:equatable/equatable.dart';
import 'package:recollar/models/user.dart';
import 'package:recollar/models/user_auth.dart';

abstract class LoginState extends Equatable{
  final UserAuth userAuth;
  const LoginState(this.userAuth);
  @override
  List<Object> get props =>[userAuth];

}
class LoginInitial extends LoginState{
  LoginInitial() : super(UserAuth("", ""));
}
class LoginOk extends LoginState{
  final User user;
  const LoginOk(UserAuth userAuth,this.user) : super(userAuth);
}
class LoginFailed extends LoginState{
  const LoginFailed(UserAuth userAuth) : super(userAuth);
}
class LoginLoading extends LoginState{
  LoginLoading() : super(UserAuth("", ""));
}
class SignupLoading extends LoginState{
  SignupLoading() : super(UserAuth("", ""));
}
class SignupPage extends  LoginState{
  SignupPage() : super(UserAuth("", ""));
}
class LoginPage extends  LoginState{
  const LoginPage(UserAuth userAuth) : super(userAuth);
}