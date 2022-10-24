import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notesapp/app/component/crud.dart';
import 'package:notesapp/app/component/customtextform.dart';
import 'package:notesapp/app/component/valid.dart';
import 'package:notesapp/constant/linksapi.dart';
import 'package:notesapp/main.dart';
import 'dart:io';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> with Crud {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  bool isLoading = false;
  File? myfile;

  addNote() async {
    if (myfile == null)
      return AwesomeDialog(
          context: context, title: "Important", body: Text("you don't upload an image"))
        ..show();

    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequestWithFile(
          linkAddNotes,
          {
            "id": sharedPref.getString("id"),
            "title": title.text,
            "content": content.text,
          },
          myfile!);
      isLoading = false;
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
        title: const Text('Add Notes'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: formState,
                child: ListView(
                  children: [
                    CusTextForm(
                        hint: "Title here..",
                        mycontroller: title,
                        valid: (value) {
                          return validInput(value!, 1, 20);
                        }),
                    CusTextForm(
                        hint: "Content here..",
                        mycontroller: content,
                        valid: (value) {
                          return validInput(value!, 10, 200);
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                        child: Text("Upload Image"),
                        textColor: Colors.white,
                        color: myfile == null ? Colors.blue : Colors.green,
                        onPressed: () {
                          //await addNote();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                    height: 150,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              "Please Choose Image",
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              XFile? xfile = await ImagePicker()
                                                  .pickImage(source: ImageSource.gallery);
                                              Navigator.of(context).pop();
                                              myfile = File(xfile!.path);
                                              setState(() {});
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                "From Gallery",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              XFile? xfile = await ImagePicker()
                                                  .pickImage(source: ImageSource.camera);
                                              Navigator.of(context).pop();
                                              myfile = File(xfile!.path);
                                              setState(() {});
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                "From Camera",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          )
                                        ]),
                                  ));
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                        child: Text("Add Note"),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {
                          await addNote();
                        })
                  ],
                ),
              ),
            ),
    );
  }
}
