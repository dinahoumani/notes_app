import 'package:flutter/material.dart';
import 'package:notes_app/ModelClass/NoteModel.dart';
import 'package:notes_app/constants/linkapi.dart';

class CardNote extends StatelessWidget {
  final NoteModel notemodel;
  final void Function() ondeleteTap;
  final void Function() onTap;
  CardNote(this.notemodel, this.onTap, this.ondeleteTap, {super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "$linkImageRoot/${notemodel.notesImage}",
                width: 80,
                height: 80,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text(notemodel.notesTitle!),
                subtitle: Text(notemodel.notesContent!),
                trailing: IconButton(
                    onPressed: ondeleteTap,
                    icon: Icon(
                      Icons.delete,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
