import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validatorless/validatorless.dart';
import '../../repositories/shared_preferences.dart';
import '../../widgets/snack_bar.dart';
import 'esqueci_senha.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool obscure = true;
  bool isChecked = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildTextFormEmail() {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: userController, autofillHints: const [AutofillHints.email],

        validator: Validatorless.multiple(
            [Validatorless.required('Preencha com seu login')]),
        // autofillHints: [AutofillHints.email],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.height * 0.020,
          ),
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
        // style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color,.colorScheme.primary),
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
              Validatorless.required('Preencha com sua senha de acesso'),
              Validatorless.min(6, 'Mínimo de 6 caracteres')
            ]),
            onEditingComplete: () => TextInput.finishAutofillContext(),
            autofillHints: const [AutofillHints.password],
            obscureText: obscure,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.020,
              ),
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
            // style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          ConstsWidget.buildPadding001(
            context,
            child: StatefulBuilder(builder: (context, setState) {
              return ConstsWidget.buildCheckBox(context, isChecked: isChecked,
                  onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
                FocusManager.instance.primaryFocus!.unfocus();
              }, title: 'Mantenha-me conectado');
            }),
          )
        ],
      );
    }

    starLogin() {
      setState(() {
        isLoading = !isLoading;
        var formValid = _formKeyLogin.currentState?.validate() ?? false;
        if (formValid && isChecked) {
          LocalInfos.createCache(userController.text, senhaController.text)
              .whenComplete(() {
            setState(() {
              isLoading = !isLoading;
            });
            ConstsFuture.fazerLogin(
                context, userController.text, senhaController.text);
          });

          ConstsFuture.fazerLogin(
              context, userController.text, senhaController.text);
        } else if (formValid && !isChecked) {
          setState(() {
            isLoading = !isLoading;
          });
          ConstsFuture.fazerLogin(
              context, userController.text, senhaController.text);
        } else {
          buildMinhaSnackBar(
            context,
            hasError: true,
          );
        }
      });
    }

    return Scaffold(
      body: AutofillGroup(
        child: Form(
          key: _formKeyLogin,
          child: ConstsWidget.buildPadding001(
            context,
            horizontal: 0.02,
            vertical: 0.03,
            child: ListView(
              children: [
                Center(
                  child: ConstsWidget.buildCachedImage(context,
                      height: 0.27,
                      width: SplashScreen.isSmall ? 0.5 : 0.55,
                      iconApi:
                          'https://a.portariaapp.com/img/logo_vermelho.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: size.height * 0.035, top: size.height * 0.025),
                  child: ConstsWidget.buildTitleText(context,
                      textAlign: TextAlign.center,
                      title: 'Portaria App | Portaria',
                      fontSize: 19),
                ),
                buildTextFormEmail(),
                SizedBox(
                  height: size.height * 0.03,
                ),
                buildTextFormSenha(),
                ConstsWidget.buildLoadingButton(context, fontSize: 18,
                    onPressed: () async {
                  starLogin();
                }, isLoading: isLoading, title: 'Entrar'),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EsqueciSenhaScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Recuperar Senha',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
