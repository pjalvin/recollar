class UserAuth{
  String password;
  String email;
  UserAuth(this.password,this.email);

  Map <String,dynamic> toJson()=>{
    "password":password,
    "username":email,
    "grant_type":"password"
  };
  void verifyData(){
    if(password.isEmpty||email.isEmpty){
      throw "Verifique que todos los capos esten llenos";
    }
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if(!emailValid){
      throw "El formato de email no es correcto";
    }
  }

}