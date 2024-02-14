import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextfor.dart';
import 'package:notes_app/constants/linkapi.dart';
import 'package:notes_app/main.dart';

class AddNote extends StatefulWidget {
  AddNote({super.key});
  @override
  State<AddNote> createState() {
    return _AddNoteState();
  }
}

class _AddNoteState extends State<AddNote> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();

  Crud _crud = Crud();
  File? myfile;
  addNote() async {
    if (myfile == null) {
      return "please enter an image";
    }
    if (formState.currentState!.validate()) {
      var response = await _crud.postRequestWithFiles(
          linkAddNote,
          {
            "title": title.text,
            "content": content.text,
            "userid": sharedpref.getString("id"),
          },
          myfile!);
      setState(() {});
      if (response['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("home");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formState,
          child: ListView(
            children: [
              CustTextForm((p0) {
                if (p0!.length == 0) {
                  return "title cannot be empty";
                }
                return null;
              }, "title", title),
              CustTextForm((p0) {
                if (p0!.length == 0) {
                  return "note cannot be empty";
                }
                return null;
              }, "content", content),
              MaterialButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      alignment: Alignment.center,
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            child: Text(
                              "Gallery",
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () async {
                              XFile? xfile = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              setState(() {
                                myfile = File(xfile!.path);
                              });
                            },
                          ),
                          InkWell(
                            child: Text(
                              "Camera",
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () async {
                              XFile? xfile = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);

                              setState(() {
                                myfile = File(xfile!.path);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text("Choose Image"),
                textColor: Colors.white,
                color: myfile == null
                    ? const Color.fromARGB(255, 77, 95, 110)
                    : Colors.green,
              ),
              MaterialButton(
                onPressed: () async {
                  await addNote();
                },
                child: Text("Add"),
                textColor: Colors.white,
                color: const Color.fromARGB(255, 77, 95, 110),
              )
            ],
          ),
        ),
      ),
    );
  }
}
