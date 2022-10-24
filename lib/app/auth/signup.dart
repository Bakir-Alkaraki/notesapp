import 'package:flutter/material.dart';
import 'package:notesapp/app/component/crud.dart';
import 'package:notesapp/app/component/customtextform.dart';
import 'package:notesapp/app/component/valid.dart';
import 'package:notesapp/constant/linksapi.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController user = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Crud _crud = Crud();

  signUp() async {
    if (formState.currentState!.validate()) {
      var response = await _crud.postRequest(linkSignUp, {
        "username": user.text,
        "email": email.text,
        "password": password.text,
      });
      if (response['status'] == "success") {
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        print("SignUp Failed!");
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
                    hint: "User Name",
                    mycontroller: user,
                    valid: (val) {
                      return validInput(val!, 5, 40);
                    },
                  ),
                  CusTextForm(
                    valid: (val) {
                      return validInput(val!, 3, 20);
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
                    child: Text("SignUp"),
                    onPressed: () async {
                      await signUp();
                    },
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    child: Text("Login =>"),
                    onTap: () {
                      Navigator.of(context).pushNamed("login");
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
