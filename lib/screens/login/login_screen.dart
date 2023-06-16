import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validatorless/validatorless.dart';
import '../../consts/consts.dart';
import '../../repositories/shared_preferences.dart';
import '../../widgets/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController userController =
      TextEditingController(text: 'porteirodocondominio');
  final TextEditingController senhaController =
      TextEditingController(text: '123456');
  bool obscure = true;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildTextFormEmail() {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: userController,
        validator: Validatorless.multiple([
          Validatorless.required('Usuário é obrigatório'),
          // Validatorless.email('Preencha com um email Válido')
        ]),
        // autofillHints: [AutofillHints.email],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: size.width * 0.04),
          filled: true,
          fillColor: Theme.of(context).canvasColor,
          hintText: 'Digite seu usuário',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black26),
          ),
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      );
    }

    Widget buildTextFormSenha() {
      return Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.done,
            controller: senhaController,

            // autofillHints: [AutofillHints.password],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: Validatorless.multiple([
              Validatorless.required('Senha é obrigatório'),
              Validatorless.min(3, 'Mínimo de 6 caracteres')
            ]),
            onEditingComplete: () => TextInput.finishAutofillContext(),
            obscureText: obscure,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: size.width * 0.04),
              filled: true,
              fillColor: Theme.of(context).canvasColor,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.black26),
              ),
              hintText: 'Digite sua Senha',
              suffixIcon: GestureDetector(
                onTap: (() {
                  setState(() {
                    obscure = !obscure;
                  });
                }),
                child: obscure
                    ? Icon(Icons.visibility_off_outlined)
                    : Icon(Icons.visibility_outlined),
              ),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          StatefulBuilder(builder: (context, setState) {
            return CheckboxListTile(
              title: ConstsWidget.buildTitleText(context,
                  title: 'Mantenha-me conectado'),
              value: isChecked,
              activeColor: Consts.kButtonColor,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            );
          })
        ],
      );
    }

    return Scaffold(
      body: Form(
        key: _formKeyLogin,
        child: Center(
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.05),
                      child: ConstsWidget.buildTitleText(context,
                          title: 'App Porteiro'),
                    ),
                    buildTextFormEmail(),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    buildTextFormSenha(),
                    ElevatedButton(
                      onPressed: () async {
                        var formValid =
                            _formKeyLogin.currentState?.validate() ?? false;
                        if (formValid && isChecked) {
                          LocalInfos.createCache(
                                  userController.text, senhaController.text)
                              .whenComplete(() => ConstsFuture.fazerLogin(
                                  context,
                                  userController.text,
                                  senhaController.text));

                          ConstsFuture.fazerLogin(context, userController.text,
                              senhaController.text);
                        } else if (formValid && !isChecked) {
                          return ConstsFuture.fazerLogin(context,
                              userController.text, senhaController.text);
                        } else {
                          buildMinhaSnackBar(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Consts.kButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.023),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Entrar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
