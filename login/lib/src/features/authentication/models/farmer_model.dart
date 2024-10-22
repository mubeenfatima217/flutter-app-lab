class FarmerModel{

  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;


  const FarmerModel({
    this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNo,

  });

  toJson(){
    return{
      "FullName": fullName,
      "Email": email,
      "Phone": phoneNo,
      "Password": password,
    };
  }
}
