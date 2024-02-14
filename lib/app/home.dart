import 'package:flutter/material.dart';
import 'package:notes_app/ModelClass/NoteModel.dart';
import 'package:notes_app/app/notes/editnote.dart';
import 'package:notes_app/components/cardnote.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/constants/linkapi.dart';
import 'package:notes_app/main.dart';

class Home extends StatefulWidget {
  Home({super.key});
  @override
  State<Home> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Crud _crud = Crud();

  getnote() async {
    var response =
        _crud.postRequest(linkViewNote, {"userid": sharedpref.getString("id")});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("add note");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              sharedpref.clear();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("login", (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
                future: getnote(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null &&
                        snapshot.data['data'] != null) {
                      return ListView.builder(
                          itemCount: snapshot.data['data'].length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return CardNote(
                                NoteModel.fromJson(snapshot.data['data'][i]),
                                () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditNote(notes: snapshot.data['data'][i]),
                                ),
                              );
                            }, () async {
                              var response1 =
                                  _crud.postRequest(linkDeleteNote, {
                                "notesid": snapshot.data['data'][i]['notes_id']
                                    .toString(),
                                "imagename": snapshot.data['data'][i]
                                        ['notes_image']
                                    .toString(),
                              });
                              setState(() {});
                              if (response1['status' == "success"]) {
                                setState(() {});
                                Navigator.of(context)
                                    .pushReplacementNamed('home');
                              }
                              ;
                            });
                          });
                    } else {
                      return Center(
                        child: Text("notes are empty"),
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading..."),
                    );
                  }
                  return Center(
                    child: Text("Loading..."),
                  );
                })
          ],
        ),
      ),
    );
  }
}
