import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextfor.dart';
import 'package:notes_app/constants/linkapi.dart';

class EditNote extends StatefulWidget {
  final notes;
  EditNote({required this.notes, super.key});
  @override
  State<EditNote> createState() {
    return _EditNoteState();
  }
}

class _EditNoteState extends State<EditNote> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  File? myfile;
  Crud _crud = Crud();

  editNote() async {
    if (formState.currentState!.validate()) {
      var response;
      if (myfile == null) {
        //which means eno eza ma aamil upload la soura bl edit part bye3ne eno ma bado yghayir l soura, so hek ma bejbro yghayir l soura, fi bas yghayir l content or l title
        response = await _crud.postRequest(linkEditNote, {
          "notesid": widget.notes['notes_id'].toString(),
          "title": title.text,
          "content": content.text,
          "imagename": widget.notes['notes_image'].toString(),
        });
      } else {
        response = await _crud.postRequestWithFiles(
            linkEditNote,
            {
              "notesid": widget.notes['notes_id'].toString(),
              "title": title.text,
              "content": content.text,
              "imagename": widget.notes['notes_image'].toString(),
            },
            myfile!);
      }

      setState(() {});
      if (response['status'] == "success") {
        setState(() {});
        Navigator.of(context).pushReplacementNamed("home");
      }
    }
  }

  @override
  void initState() {
    title.text = widget.notes['notes_title'];
    content.text = widget.notes['notes_content'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
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
                  await editNote();
                },
                child: Text("Edit"),
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
