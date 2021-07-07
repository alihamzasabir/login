class LoginResponseModel {
  final String token;
  final String error;

  LoginResponseModel({this.token, this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] != null ? json["token"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class LoginRequestModel {
  String email;
  String password;
  int Status;

  LoginRequestModel({
    this.email,
    this.password,
    this.Status
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'UserPassword': email,
      'UserName': password,
      'Status': Status,

    };

    return map;
  }
}
