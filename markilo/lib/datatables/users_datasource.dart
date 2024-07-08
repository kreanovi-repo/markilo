import 'package:markilo/models/user.dart';
import 'package:flutter/material.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/navigation_service.dart';

class UsersDTS extends DataTableSource {
  final List<User> users;

  UsersDTS(this.users);

  @override
  DataRow getRow(int index) {
    final user = users[index];
    //print("Imagen: ${user.image}");
    final image = (user.image == null)
        ? const Image(
            image: AssetImage('assets/images/no-image.jpg'),
            width: 35,
            height: 35,
          )
        : FadeInImage.assetNetwork(
            placeholder: 'assets/images/loader.gif',
            image: user.image!,
            width: 35,
            height: 35,
          );

    return DataRow.byIndex(index: index, cells: [
      DataCell(ClipOval(child: image)),
      DataCell(Text(user.id.toString())),
      DataCell(Text(user.name)),
      DataCell(Text(user.surname)),
      DataCell(Text(user.email)),
      DataCell(Row(
        children: [
          IconButton(
              onPressed: () {
                NavigationService.replaceTo(
                    '${Flurorouter.userRoute}/${user.uuid}');
              },
              icon: const Icon(Icons.edit_outlined)),
          IconButton(
              onPressed: () {
                NavigationService.replaceTo(
                    '${Flurorouter.userRoute}/${user.uuid}');
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              )),
        ],
      ))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
