class PasswordRequest{
  String oldPassword;
  String newPassword;

  PasswordRequest(this.oldPassword, this.newPassword);
  Map <String,dynamic> toJson()=>{
    "oldPassword":oldPassword,
    "newPassword":newPassword
  };
  void verifyData(){
    if(oldPassword.isEmpty||newPassword.isEmpty){
      throw "Verifique que todos los capos esten llenos";
    }
  }


}
