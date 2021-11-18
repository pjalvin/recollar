class ProfileRequest{
  String firstName;
  String lastName;
  int phoneNumber;

  ProfileRequest(this.firstName, this.lastName, this.phoneNumber);

  Map <String,dynamic> toJson()=>{
    "firstName":firstName,
    "lastName":lastName,
    "phoneNumber":phoneNumber,
  };
  void verifyData(){
    if(firstName.isEmpty||lastName.isEmpty||phoneNumber==0){
      throw "Verifique que todos los capos esten llenos";
    }
    if(phoneNumber.toString().length!=8){
      throw "Formato de numero de celular incorrecto";
    }

  }
}