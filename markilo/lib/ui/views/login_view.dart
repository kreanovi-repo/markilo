import 'package:email_validator/email_validator.dart';
import 'package:markilo/providers/auth_provider.dart';
import 'package:markilo/providers/login_form_provider.dart';
import 'package:markilo/ui/buttons/custom_outlined_button.dart';
import 'package:markilo/ui/inputs/custom_inputs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => LoginFormProvider(),
        child: Builder(builder: (context) {
          final loginFormProvider =
              Provider.of<LoginFormProvider>(context, listen: false);
          final authProvider = Provider.of<AuthProvider>(context);
          return Container(
            margin: const EdgeInsets.only(top: 100),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.black,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 370),
                child: Form(
                  key: loginFormProvider.formKeyLogin,
                  child: Column(
                    children: [
                      // E-mail
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) => onFormSubmit(
                            context, loginFormProvider, authProvider),
                        onChanged: (value) => loginFormProvider.email = value,
                        validator: (value) {
                          if (!EmailValidator.validate(value ?? '')) {
                            return 'E-mail no válido';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: CustomInputs.loginInputsDecoration(
                            hint: 'Ingrese su e-mail',
                            label: 'E-mail',
                            icon: Icons.email_outlined),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onFieldSubmitted: (_) => onFormSubmit(
                            context, loginFormProvider, authProvider),
                        onChanged: (value) =>
                            loginFormProvider.password = value,
                        validator: (value) {
                          if (null == value || value.isEmpty) {
                            return 'Ingrese su contraseña, por favor';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: CustomInputs.loginInputsDecoration(
                            hint: 'Ingrese su contraseña',
                            label: 'Contraseña',
                            icon: Icons.lock_outline),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomOutlinedButton(
                        onPressed: () => onFormSubmit(
                            context, loginFormProvider, authProvider),
                        text: 'Ingresar',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: authProvider.loadingLogin
                              ? const CircularProgressIndicator()
                              : null),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  void onFormSubmit(BuildContext context, LoginFormProvider loginFormProvider,
      AuthProvider authProvider) {
    if (loginFormProvider.validateForm()) {
      FocusScope.of(context).unfocus();
      authProvider.login(
          context, loginFormProvider.email, loginFormProvider.password);
    }
  }
}
