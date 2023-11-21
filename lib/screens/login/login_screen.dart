import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:app_porteiro/screens/termodeuso/termo_de_uso.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validatorless/validatorless.dart';
import '../../consts/consts.dart';
import '../../repositories/shared_preferences.dart';
import '../../widgets/snack_bar.dart';
import '../politica/politica_screen.dart';
import 'esqueci_senha.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool isLoading = false;

class _LoginScreenState extends State<LoginScreen> {
  final _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool obscure = true;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
                  horizontal: size.width * 0.032,
                  vertical: size.height * 0.025),
              filled: true,
              fillColor: Theme.of(context).primaryColor,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
              hintText: 'Digite sua Senha',
              label: RichText(
                  text: TextSpan(
                      text: 'Senha',
                      style: TextStyle(
                        fontSize: SplashScreen.isSmall ? 14 : 16,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                      children: [
                    TextSpan(
                        text: ' *',
                        style: TextStyle(
                            color: Consts.kColorRed,
                            fontSize: SplashScreen.isSmall ? 14 : 16))
                  ])),
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            child: StatefulBuilder(builder: (context, setState) {
              return ConstsWidget.buildCheckBox(context, isChecked: isChecked,
                  onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
                FocusManager.instance.primaryFocus!.unfocus();
              }, title: 'Mantenha-me conectado');
            }),
          ),
        ],
      );
    }

    starLogin() {
      setState(() {
        isLoading = true;
      });

      var formValid = _formKeyLogin.currentState?.validate() ?? false;
      if (formValid && isChecked) {
        LocalInfos.createCache(userController.text, senhaController.text)
            .whenComplete(() {
              ConstsFuture.fazerLogin(
                  context, userController.text, senhaController.text);
            })
            .whenComplete(() => ConstsFuture.fazerLogin(
                context, userController.text, senhaController.text))
            .whenComplete(() {
              setState(() {
                isLoading = false;
              });
            });
      } else if (formValid && !isChecked) {
        ConstsFuture.fazerLogin(
                context, userController.text, senhaController.text)
            .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
      } else {
        buildMinhaSnackBar(
          context,
          hasError: true,
        );
      }
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
                      height: 0.2,
                      width: SplashScreen.isSmall ? 0.3 : 0.4,
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
                ConstsWidget.buildCamposObrigatorios(context),
                SizedBox(
                  height: size.height * 0.01,
                ),
                ConstsWidget.buildMyTextFormObrigatorio(
                  context,
                  'Login',
                  keyboardType: TextInputType.emailAddress,
                  controller: userController,
                  autofillHints: const [AutofillHints.email],
                  hintText: 'Digite Seu Login',
                  validator: Validatorless.multiple(
                    [
                      Validatorless.required('Obrigatório'),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                buildTextFormSenha(),
                ConstsWidget.buildLoadingButton(context, fontSize: 18,
                    onPressed: () async {
                  starLogin();
                }, isLoading: isLoading, title: 'Entrar'),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PoliticaScreen(
                                      hasDrawer: false,
                                    )));
                      },
                      child: Text(
                        'Política de Privacidade',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermoDeUsoScreen(
                              hasDrawer: false,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Termos de Uso',
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
