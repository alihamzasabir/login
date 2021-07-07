import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_max_login_test_app/api/api_service.dart';
import 'package:super_max_login_test_app/model/login_model.dart';


import '../ProgressHUD.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  LoginRequestModel loginRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                _getDetails(context),
                Container_getPic(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Container _getDetails (BuildContext context){
    return Container(
      height: 275,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: MediaQuery.of(context).size.width*.10,),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2
          ),
          borderRadius: BorderRadius.all(Radius.circular(18),)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: globalFormKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              new TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (input) => loginRequestModel.email = input,

                decoration: new InputDecoration(
                  hintText: "User Name",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .accentColor
                              .withOpacity(0.2))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor)),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              SizedBox(height: 20),
              new TextFormField(
                style:
                TextStyle(color: Theme.of(context).accentColor),
                keyboardType: TextInputType.text,
                onSaved: (input) =>
                loginRequestModel.password = input,
                validator: (input) => input.length <= 2
                    ? "Password should be more than 2 characters"
                    : null,
                obscureText: hidePassword,
                decoration: new InputDecoration(
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .accentColor
                              .withOpacity(0.2))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor)),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).accentColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Theme.of(context)
                        .accentColor
                        .withOpacity(0.4),
                    icon: Icon(hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
              ),
              SizedBox(height: 30),
              FlatButton(
                padding: EdgeInsets.symmetric(
                    vertical: 12, horizontal: 80),
                onPressed: () {
                  loginRequestModel.Status=1;
                  if (validateAndSave()) {
                    print(loginRequestModel.toJson());

                    setState(() {
                      isApiCallProcess = true;
                    });

                    APIService apiService = new APIService();
                    apiService.login(loginRequestModel).then((value) {
                      if (value != null) {
                        setState(() {
                          isApiCallProcess = false;
                        });

                        if (value.token.isNotEmpty) {
                          final snackBar = SnackBar(
                              content: Text("Login Successful"));
                          scaffoldKey.currentState
                              .showSnackBar(snackBar);
                        } else {
                          final snackBar =
                          SnackBar(content: Text(value.error));
                          scaffoldKey.currentState
                              .showSnackBar(snackBar);
                        }
                      }
                    });
                  }
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
                shape: StadiumBorder(),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
  Container_getPic(BuildContext context) {
    return Container(
        height: 70,
        width: MediaQuery.of(context).size.width*.65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(33.0)),
          border: Border.all(color: Colors.blueGrey.shade700,width: 2.0),
        ),
        child:  Center(
          child: Image.asset('assets/images/logo.png'),
        )
    );
  }
  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
