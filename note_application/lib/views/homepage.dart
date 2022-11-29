import 'package:flutter/material.dart';
import 'package:note_application/controllers/dbhelper.dart';
import 'package:note_application/models/notes_model.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper? databaseHelper;
  late Future<List<NoteModel>> noteList;
  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    loadData();
  }

  loadData() async {
    noteList = databaseHelper!.getNoteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Notes Application",
          style: TextStyle(
              color: Color.fromARGB(255, 245, 67, 126),
              fontFamily: "RubikDistressed"),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: noteList,
              builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            databaseHelper!.update(NoteModel(
                                id: snapshot.data![index].id,
                                age: 21,
                                email: "rayhanahmedrimon44@gmail.com",
                                title: "Rimon Ahmed",
                                description: "Apps Developer."));
                            setState(() {
                              noteList = databaseHelper!.getNoteList();
                            });
                          },
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                databaseHelper!
                                    .delete(snapshot.data![index].id!);
                                noteList = databaseHelper!.getNoteList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            key: ValueKey<int>(snapshot.data![index].id!),
                            background: Container(
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete_forever_rounded,
                              ),
                            ),
                            child: Card(
                              child: ListTile(
                                title:
                                    Text(snapshot.data![index].age.toString()),
                                leading: Text(
                                    snapshot.data![index].email.toString()),
                                subtitle: Text(
                                    snapshot.data![index].title.toString()),
                                trailing: Text(snapshot.data![index].description
                                    .toString()),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          databaseHelper!
              .insertData(
            NoteModel(
                age: 21,
                email: 'mhr163769@gmail.com',
                title: 'Hussainur Rahman',
                description: 'I am an App Developer'),
          )
              .then((value) {
            setState(() {
              noteList = databaseHelper!.getNoteList();
            });
          }).onError((error, stackTrace) {
            const AlertDialog(
              title: Text(
                "Error",
                style: TextStyle(color: Color.fromARGB(255, 127, 241, 217)),
              ),
              icon: Icon(Icons.error_outline_rounded),
              iconColor: Colors.redAccent,
            );
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
