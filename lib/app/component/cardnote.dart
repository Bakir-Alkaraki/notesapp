import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notesapp/model/notemodel.dart';

import '../../constant/linksapi.dart';

class CardNotes extends StatelessWidget {
  final void Function()? ontap;
  final void Function()? delete;
  final NoteModel notemodel;

  const CardNotes({Key? key, required this.delete, required this.ontap, required this.notemodel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "$linkImageRoot/${notemodel.notesImage}",
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text("${notemodel.notesTitle}"),
                subtitle: Text("${notemodel.notesContent}"),
                trailing: IconButton(onPressed: delete, icon: Icon(Icons.delete)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
