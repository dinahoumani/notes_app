import 'package:flutter/material.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextfor.dart';
import 'package:notes_app/constants/linkapi.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});
  @override
  State<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formState = GlobalKey();

  Crud _crud = Crud();

  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  signUp() async {
    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await _crud.postRequest(linkSignUp, {
        "username": username.text, //bekheda mn l controller
        "email": email.text,
        "password": password.text,
      });
      isLoading = false;
      setState(() {});
      print("Response: $response");
      if (response['status'] == "success") {
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        print("Sign up fail");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                alignment: Alignment.center,
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
                              return "username cannot be empty";
                            }
                            if (val.length > 20) {
                              return "username cannot be this long";
                            }
                            return null;
                          }, 'username', username),
                          CustTextForm((val) {
                            if (val!.isEmpty) {
                              return "email cannot be empty";
                            }
                            return null;
                          }, 'email', email),
                          CustTextForm((val) {
                            if (val!.isEmpty) {
                              return "password cannot be empty";
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
                              await signUp();
                            },
                            child: const Text("Sign up"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            child: const Text("Sign in"),
                            onPressed: () {
                              Navigator.of(context).pushNamed("login");
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
