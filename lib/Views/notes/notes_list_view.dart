import 'package:flutter/material.dart';
import 'package:myfrstapp/Services/crud/service_notes.dart';
import 'package:myfrstapp/Utilites/delete_dialog.dart';

typedef DeleteNotesCallback = void Function(DataBaseNotes note);

class NotesViewList extends StatelessWidget {
  final List<DataBaseNotes> notes;
  final DeleteNotesCallback onDelete;
  const NotesViewList({
    Key? key,
    required this.notes,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shoulddelete = await showDeleteDialog(context);
              if (shoulddelete) {
                onDelete(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
