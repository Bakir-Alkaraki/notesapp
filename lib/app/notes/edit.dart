import 'package:flutter/material.dart';

import '../../constant/linksapi.dart';
import '../../main.dart';
import '../component/crud.dart';
import '../component/customtextform.dart';
import '../component/valid.dart';

class EditNotes extends StatefulWidget {
  final notes;
  const EditNotes({Key? key, this.notes}) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> with Crud {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  bool isLoading = false;

  editNote() async {
    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequest(linkEditNotes, {
        "id": widget.notes['notes_id'].toString(),
        "title": title.text,
        "content": content.text,
      });
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("home");
      }
    }
  }

  @override
  void initState() {
    title.text = widget.notes['notes_title'];
    content.text = widget.notes['notes_content'];
    super.initState();
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
                        child: Text("Save Note"),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {
                          await editNote();
                        })
                  ],
                ),
              ),
            ),
    );
  }
}
