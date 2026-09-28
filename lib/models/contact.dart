import 'package:image_picker/image_picker.dart';

class Contact {
  final int contactId;
  final String name;
  final String mail;
  final String number;
  final XFile image;

  static int id = 0;
  Contact({
    required this.name,
    required this.mail,
    required this.number,
    required this.image,
  }) : contactId = ++id;
}
