import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/app/component/crud.dart';
import 'package:notesapp/app/component/customtextform.dart';
import 'package:notesapp/constant/linksapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:notesapp/main.dart';
import '../component/valid.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Crud _crud = Crud();

  logIn() async {
    if (formState.currentState!.validate()) {
      var response = await _crud.postRequest(linkLogin, {
        "email": email.text,
        "password": password.text,
      });
      if (response['status'] == "success") {
        sharedPref.setString("id", response['data']['id'].toString());
        sharedPref.setString("username", response['data']['username'].toString());
        sharedPref.setString("email", response['data']['email'].toString());

        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        AwesomeDialog(
            context: context,
            title: "Attention",
            btnCancel: Text("Cancel"),
            body: Text("Your passsword or email is wrong"))
          ..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                children: [
                  Image.asset(
                    "images/notes.png",
                    height: 200,
                    width: 200,
                  ),
                  CusTextForm(
                    valid: (val) {
                      return validInput(val!, 3, 40);
                    },
                    hint: "Email",
                    mycontroller: email,
                  ),
                  CusTextForm(
                    valid: (val) {
                      return validInput(val!, 3, 20);
                    },
                    hint: "Password",
                    mycontroller: password,
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    child: Text("Login"),
                    onPressed: () async {
                      await logIn();
                    },
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    child: Text("Signup =>"),
                    onTap: () {
                      Navigator.of(context).pushNamed("signup");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
