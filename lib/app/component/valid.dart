import 'package:notesapp/constant/message.dart';

validInput(String val, int min, int max) {
  if (val.isEmpty) {
    return "$messageInputEmpty";
  }
  if (val.length > max) {
    return "$messageInputMax $max";
  }
  if (val.length < min) {
    return "$messageInputMax $min";
  }
}
