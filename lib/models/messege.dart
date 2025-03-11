import 'package:chat/constants.dart';

class Messege {
  String message;
  String from;
  String to;
  Messege({required this.message, required this.from, required this.to});
  factory Messege.fromJson(dynamic jsonData) {
    return Messege(
        message: jsonData[kMessegeDoc],
        from: jsonData['from'],
        to: jsonData['to']);
  }
}
