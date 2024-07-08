import 'package:markilo/services/data_service.dart';

class User {
  User({
    required this.id,
    required this.uuid,
    required this.name,
    required this.surname,
    required this.dni,
    required this.cellPhone,
    required this.email,
    this.image,
    required this.backgroundColorVoley,
  });

  int id;
  String uuid;
  String name;
  String surname;
  int dni;
  String cellPhone;
  String email;
  String? image;
  String backgroundColorVoley;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
        dni: json["dni"],
        cellPhone: json["cell_phone"],
        surname: json["surname"],
        email: json["email"],
        image: json["image"] == null
            ? null
            : '${DataService.configuration!['baseUrl']!}/${json["image"]}',
        backgroundColorVoley: json["background_color_voley"],
      );
}
