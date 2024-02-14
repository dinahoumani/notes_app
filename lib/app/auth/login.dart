import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextfor.dart';
import 'package:notes_app/constants/linkapi.dart';
import 'package:notes_app/main.dart';

class Login extends StatefulWidget {
  Login({super.key});
  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Crud crud = Crud();

  login() async {
    if (formState.currentState!.validate()) {
      setState(() {
        isLoading = true; // Start loading indicator
      });

      var response = await crud.postRequest(linkLogin, {
        "email": email.text,
        "password": password.text,
      });

      setState(() {
        isLoading = false; // Stop loading indicator
      });

      if (response['status'] == "success") {
        await sharedpref.setString("id", response['data']['id'].toString());
        await sharedpref.setString("username", response['data']['username']);
        await sharedpref.setString("email", response['data']['email']);
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        AwesomeDialog(
          context: context,
          title: "Error",
          body: const Text("Email or password entered are wrong"),
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    Form(
                      key: formState,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/note-taking.png',
                              width: 130, height: 130),
                          CustTextForm((val) {
                            if (val!.isEmpty) {
                              return "enter email";
                            }
                            return null;
                          }, 'email', email),
                          CustTextForm((val) {
                            if (val!.isEmpty) {
                              return "enter password";
                            }
                            return null;
                          }, 'password', password),
                          MaterialButton(
                            color: const Color.fromARGB(255, 88, 99, 109),
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 70,
                              vertical: 10,
                            ),
                            onPressed: () async {
                              await login();
                            },
                            child: const Text("Login"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            child: const Text("Sign up"),
                            onPressed: () {
                              Navigator.of(context).pushNamed("sign up");
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
