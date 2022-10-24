import 'package:flutter/material.dart';

class CusTextForm extends StatelessWidget {
  final String hint;
  final TextEditingController mycontroller;
  final String? Function(String?)? valid;

  const CusTextForm(
      {Key? key,
      required this.hint,
      required this.mycontroller,
      required this.valid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: valid,
        controller: mycontroller,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            hintText: hint,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            )),
      ),
    );
  }
}
