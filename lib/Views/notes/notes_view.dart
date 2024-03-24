import 'package:flutter/material.dart';
import 'package:myfrstapp/Services/auth/auth_service.dart';
import 'package:myfrstapp/Services/crud/service_notes.dart';
import 'package:myfrstapp/Utilites/logout_dialog.dart';
import 'package:myfrstapp/Views/notes/notes_list_view.dart';
import 'package:myfrstapp/constants/routes.dart';
import 'package:myfrstapp/enums/menu.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNotesRoutes);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAcion>(
            onSelected: (value) async {
              switch (value) {
                case MenuAcion.logout:
                  final shouldLogout = await showlogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoutes,
                        (route) => false,
                      );
                    }
                  }
                  Devtools.log(shouldLogout.toString());
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAcion>(
                  value: MenuAcion.logout,
                  child: Text('Logout'),
                )
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreatUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _notesService.allNotes,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as List<DataBaseNotes>;
                            return NotesViewList(
                                notes: allNotes,
                                onDelete: (notes) async {
                                  await _notesService.deleteNote(id: notes.id);
                                });
                          } else {
                            return const CircularProgressIndicator();
                          }
                        default:
                          return const CircularProgressIndicator();
                      }
                    });
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}

class Devtools {
  static void log(String string) {}
}
