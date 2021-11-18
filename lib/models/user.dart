class User {
  String email;
  String firstName;
  String lastName;
  int phoneNumber;
  String  password;
  String ? verPassword;
  String ? imagePath;

  User(this.email, this.firstName, this.lastName, this.phoneNumber,this.password);

  Map <String,dynamic> toJson()=>{
    "firstName":firstName,
    "lastName":lastName,
    "phoneNumber":phoneNumber,
    "password":password,
    "email":email,
  };
  User.fromJson(json ):
        firstName=json["firstName"],
        email=json["email"],
        lastName=json["lastName"],
        phoneNumber=json["phoneNumber"],
        imagePath=json["imagePath"]??"",
        password="";
  void verifyData(){
    if(password.isEmpty||email.isEmpty||firstName.isEmpty||lastName.isEmpty||phoneNumber==0){
      throw "Verifique que todos los capos esten llenos";
    }
    if(phoneNumber.toString().length!=8){
      throw "Formato de numero de celular incorrecto";

    }
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if(!emailValid){
      throw "El formato de email no es correcto";
    }
    if(verPassword!=password){
      throw "Las contraseñas no coinciden";
    }

  }

  @override
  String toString() {
    return 'User{email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, password: $password, verPassword: $verPassword, imagePath: $imagePath}';
  }
}