import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recollar/bloc/login_bloc.dart';
import 'package:recollar/events/login_event.dart';
import 'package:recollar/repositories/login_repository.dart';
import 'package:recollar/screens/login/login.dart';
import 'package:recollar/screens/signup/signup.dart';
import 'package:recollar/state/login_state.dart';
import 'package:recollar/util/configuration.dart';

import 'app_main.dart';

class InitialMain extends StatefulWidget {
  const InitialMain({Key? key}) : super(key: key);

  @override
  _InitialMainState createState() => _InitialMainState();
}

class _InitialMainState extends State<InitialMain> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>LoginBloc(LoginRepository())..add(LoginVerify()),
      child: BlocBuilder<LoginBloc,LoginState>(
        builder: (BuildContext context, state)
        {
            if(state is LoginOk){
              return AppMain();
            }
            if(state is SignupPage||state is SignupLoading){
              return const Signup();
            }
            if(state is LoginInitial){
              return Container(
                color: color2,
                child: const Center(
                  child: SpinKitFadingCube(
                      color: Colors.white,
                      size: 30
                  ) ,
                ),
              );
            }
            else{
              return const Login();
            }
        },

      ),
    );
  }
}

