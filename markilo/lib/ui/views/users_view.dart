import 'package:markilo/datatables/users_datasource.dart';
import 'package:markilo/providers/users_provider.dart';
import 'package:markilo/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final usersDataSource = UsersDTS(usersProvider.users);
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        /*Text(
          'Usuarios',
          style: CustomLabels.h1,
        ),
        SizedBox(
          height: 10,
        ),*/
        PaginatedDataTable(
          sortAscending: usersProvider.ascending,
          sortColumnIndex: usersProvider.sortColumnIndex,
          columns: [
            const DataColumn(label: Text("Avatar")),
            DataColumn(
                label: const Text("Id"),
                onSort: (colIndex, _) {
                  usersProvider.sortColumnIndex = colIndex;
                  usersProvider.sort((user) => user.id);
                }),
            DataColumn(
                label: const Text("Nombre"),
                onSort: (colIndex, _) {
                  usersProvider.sortColumnIndex = colIndex;
                  usersProvider.sort((user) => user.name);
                }),
            DataColumn(
                label: const Text("Apellido"),
                onSort: (colIndex, _) {
                  usersProvider.sortColumnIndex = colIndex;
                  usersProvider.sort((user) => user.surname);
                }),
            DataColumn(
                label: const Text("E-mail"),
                onSort: (colIndex, _) {
                  usersProvider.sortColumnIndex = colIndex;
                  usersProvider.sort((user) => user.email);
                }),
            const DataColumn(label: Text("Acciones"))
          ],
          header: const Text(
            'Usuarios',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    const Icon(
                      LineIcons.userPlus,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Nuevo usuario',
                      style: CustomLabels.textButton,
                    ),
                  ],
                )),
            const SizedBox(
              width: 20,
            ),
          ],
          source: usersDataSource,
          onPageChanged: (page) {
            //print('page: $page');
          },
        )
      ],
    );
  }
}
