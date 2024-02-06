import 'package:flutter/material.dart';
import 'package:todo_sqlite/db_handler.dart';
import 'package:todo_sqlite/model.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  DBHelper? dbHelper;
  late Future<List<noteModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    Loaddata();
  }

  Loaddata() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade200,
        title: Text('Note app'),
      ),
      body: Column(children: [
        Padding(padding: EdgeInsets.all(8)),
        Expanded(
          child: FutureBuilder(
              future: notesList,
              builder: (context, AsyncSnapshot<List<noteModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            dbHelper!.update(noteModel(
                                id: snapshot.data![index].id,
                                title: 'updated',
                                age: 21,
                                description: 'to do list with update',
                                email: 'jaydobariya'));
                            setState(() {
                              notesList = dbHelper!.getNotesList();
                              print('data updated');
                            });
                          },
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                dbHelper!.delete(snapshot.data![index].id!);
                                notesList = dbHelper!.getNotesList();
                                snapshot.data!.remove(snapshot.data![index]);
                                print('data delete');
                              });
                            },
                            background: Container(
                              color: Colors.red,
                              child: Icon(Icons.delete_forever_rounded),
                            ),
                            key: ValueKey<int>(snapshot.data![index].id!),
                            child: Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.all(8),
                                title: Text(
                                    snapshot.data![index].title.toString()),
                                subtitle: Text(snapshot.data![index].description
                                    .toString()),
                                trailing:
                                    Text(snapshot.data![index].age.toString()),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper!
              .insert(noteModel(
                  title: 'to do',
                  age: 21,
                  description: 'learn sqlite',
                  email: 'jaydobariya2341@gmail.com'))
              .then((value) {
            print('data added');
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
