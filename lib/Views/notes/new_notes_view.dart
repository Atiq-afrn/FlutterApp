import 'package:flutter/material.dart';
import 'package:myfrstapp/Services/auth/auth_service.dart';
import 'package:myfrstapp/Services/crud/service_notes.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({Key? key}) : super(key: key);

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  DataBaseNotes? _notes;
  late final NotesService _notesService;
  late final TextEditingController _textcontroller;
  @override
  void initState() {
    _notesService = NotesService();
    _textcontroller = TextEditingController();
    super.initState();
  }

  void _textControllerListeners() async {
    final note = _notes;
    if (note == null) {
      return;
    }
    final text = _textcontroller.text;
    await _notesService.updateNotes(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textcontroller.removeListener(_textControllerListeners);
    _textcontroller.addListener(_textControllerListeners);
  }

  Future<DataBaseNotes>? creatNewNotes() async {
    final existingNote = _notes;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.creatNotes(owner: owner);
  }

  void _deleteNotesIfTextEmpty() {
    final note = _notes;
    if (_textcontroller.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNotesIfTextNotEmpty() async {
    final note = _notes;
    final text = _textcontroller.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNotes(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNotesIfTextEmpty();
    _saveNotesIfTextNotEmpty();
    _textcontroller.text;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New notes'),
      ),
      body: FutureBuilder(
        future: creatNewNotes(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _notes = snapshot.data as DataBaseNotes?;
              _setupTextControllerListener();
              return TextField(
                controller: _textcontroller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Type Your new notes',
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
