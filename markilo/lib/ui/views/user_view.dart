import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:markilo/models/user.dart';
import 'package:markilo/providers/user_form_provider.dart';
import 'package:markilo/providers/users_provider.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/data_service.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/services/notification_service.dart';
import 'package:markilo/ui/cards/white_card.dart';
import 'package:markilo/ui/inputs/custom_inputs.dart';
import 'package:markilo/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserView extends StatefulWidget {
  const UserView({super.key, required this.uuid});

  final String uuid;

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  User? user;

  @override
  void initState() {
    super.initState();
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final userFormProvider =
        Provider.of<UserFormProvider>(context, listen: false);

    usersProvider.getUserByUuid(widget.uuid).then((userDb) {
      if (null != userDb) {
        userFormProvider.user = userDb;
        userFormProvider.formKey = GlobalKey<FormState>();
        setState(() {
          user = userDb;
        });
      } else {
        NavigationService.replaceTo('/dashboard/users');
      }
    });
    debugPrint(widget.uuid);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        Text(
          'Usuario',
          style: CustomLabels.h1,
        ),
        const SizedBox(
          height: 10,
        ),
        if (null == user)
          WhiteCard(
            child: Container(
              alignment: Alignment.center,
              height: 300,
              child: const CircularProgressIndicator(),
            ),
          ),
        if (null != user) const _UserViewBody()
      ],
    );
  }
}

class _UserViewBody extends StatelessWidget {
  const _UserViewBody();

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {0: FixedColumnWidth(250)},
      children: const [
        TableRow(children: [
          // Avatar
          _AvatarContainer(),

          // Formulario
          _UserViewForm()
        ])
      ],
    );
  }
}

class _UserViewForm extends StatelessWidget {
  const _UserViewForm();

  @override
  Widget build(BuildContext context) {
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final user = userFormProvider.user;

    return WhiteCard(
        title: 'Datos del usuario',
        child: Form(
            key: userFormProvider.formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                TextFormField(
                    initialValue: user!.name,
                    onChanged: (value) {
                      user.name = value;
                      userFormProvider.updateListener();
                    },
                    validator: (value) {
                      if (null == value || value.isEmpty) {
                        return 'Nombre incorrecto';
                      }
                      if (value.length < 2) {
                        return 'El nombre debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                    decoration: CustomInputs.defaultInputsDecoration(
                        hint: 'Nombre del usuario',
                        label: 'Nombre',
                        icon: Icons.account_box_outlined)),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                    initialValue: user.surname,
                    onChanged: (value) => user.surname = value,
                    validator: (value) {
                      if (null == value || value.isEmpty) {
                        return 'Apellido incorrecto';
                      }
                      if (value.length < 2) {
                        return 'El apellido debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                    decoration: CustomInputs.defaultInputsDecoration(
                        hint: 'Apellido del usuario',
                        label: 'Apellido',
                        icon: Icons.contact_mail_outlined)),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: user.email,
                  onChanged: (value) => user.email = value,
                  decoration: CustomInputs.defaultInputsDecoration(
                      hint: 'E-mail del usuario',
                      label: 'E-mail',
                      icon: Icons.mark_email_unread_outlined),
                  validator: (value) {
                    if (!EmailValidator.validate(value ?? '')) {
                      return 'E-mail no válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CancelButton(),
                    const SizedBox(
                      width: 5,
                    ),
                    SaveButton(userFormProvider: userFormProvider, user: user),
                  ],
                )
              ],
            )));
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.userFormProvider,
    required this.user,
  });

  final UserFormProvider userFormProvider;
  final User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 155,
      child: ElevatedButton(
          onPressed: () async {
            final saved = await userFormProvider.updateUser(DataService.user!);
            if (saved) {
              NotificationService.showSnackbar('Usuario actualizado');
              if (context.mounted) {
                Provider.of<UsersProvider>(context, listen: false)
                    .refreshUser(user);
              }
              NavigationService.replaceTo(Flurorouter.usersRoute);
            } else {
              NotificationService.showSnackbarError(
                  'No se pudo actualizar el usuario');
            }
          },
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(Colors.green.withOpacity(0.75)),
              shadowColor: WidgetStateProperty.all(Colors.transparent)),
          child: Row(
            children: [
              const Icon(
                Icons.save_outlined,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('Guardar', style: TextStyle(fontSize: 16)),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: 15,
                  height: 15,
                  child: userFormProvider.updating
                      ? const CircularProgressIndicator()
                      : null)
            ],
          )),
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: ElevatedButton(
          onPressed: () {
            NavigationService.replaceTo(Flurorouter.usersRoute);
          },
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(Colors.red.withOpacity(0.75)),
              shadowColor: WidgetStateProperty.all(Colors.transparent)),
          child: const Row(
            children: [
              Icon(
                Icons.cancel_outlined,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Cancelar',
                style: TextStyle(fontSize: 16),
              ),
            ],
          )),
    );
  }
}

class _AvatarContainer extends StatelessWidget {
  const _AvatarContainer();

  @override
  Widget build(BuildContext context) {
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final user = userFormProvider.user;
    final imageUser = (user!.image == null)
        ? const Image(image: AssetImage('assets/images/no-image.jpg'))
        : FadeInImage.assetNetwork(
            placeholder: 'assets/images/loader.gif', image: user.image!);

    return WhiteCard(
        width: 250,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Profile',
                style: CustomLabels.h3.copyWith(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 150,
                height: 160,
                child: Stack(
                  children: [
                    ClipOval(child: imageUser),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.white, width: 5)),
                        child: FloatingActionButton(
                          backgroundColor: Colors.green,
                          elevation: 0,
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['png']);
                            if (result != null) {
                              PlatformFile file = result.files.first;
                              if (context.mounted) {
                                NotificationService.showBusyIndicator(context);
                              }
                              final updatedUser =
                                  await userFormProvider.uploadImage(
                                      '/user/upload-image/${user.uuid}',
                                      file.bytes!);
                              user.image = updatedUser.image;
                              if (context.mounted) {
                                Provider.of<UsersProvider>(context,
                                        listen: false)
                                    .refreshUser(user);
                              }
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}
