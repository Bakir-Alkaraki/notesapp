import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/app/notes/edit.dart';
import 'package:notesapp/constant/linksapi.dart';
import 'package:notesapp/main.dart';
import 'package:notesapp/model/notemodel.dart';

import 'component/cardnote.dart';
import 'component/crud.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with Crud {
  getNotes() async {
    var response = await postRequest(linkViewNotes, {"id": sharedPref.getString("id")});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes Home"),
        actions: [
          IconButton(
              onPressed: () {
                sharedPref.clear();
                Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnotes");
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
              future: getNotes(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['status'] == 'fail') {
                    return Center(
                      child: Text(
                        "There is no notes",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data['data'].length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return CardNotes(
                        ontap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditNotes(
                                    notes: snapshot.data['data'][i],
                                  )));
                        },
                        notemodel: NoteModel.fromJson(snapshot.data['data'][i]),
                        delete: () async {
                          var response = await postRequest(linkDeleteNotes,
                              {"id": snapshot.data['data'][i]['notes_id'].toString()});

                          if (response['status'] == "success") {
                            Navigator.of(context).pushReplacementNamed("home");
                          }
                        },
                      );
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Center(child: Text("Loading"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
