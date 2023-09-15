import 'dart:convert';

import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:http/http.dart' as http;
import 'package:validatorless/validatorless.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/my_textform_field.dart';
import '../../widgets/snack_bar.dart';
import '../home/home_page.dart';

class EmiteEntregaScreen extends StatefulWidget {
  final int? idunidade;
  final String? protocoloRetirada;
  final String? tipoCompara;
  final String? listEntregar;
  final int? idMorador;
  const EmiteEntregaScreen(
      {required this.idunidade,
      this.protocoloRetirada,
      required this.tipoCompara,
      this.listEntregar,
      this.idMorador,
      super.key});

  @override
  State<EmiteEntregaScreen> createState() => _EmiteEntregaScreenState();
}

bool obscure = false;

class _EmiteEntregaScreenState extends State<EmiteEntregaScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController codigoConfirCrtl = TextEditingController();
  TextEditingController documento_portadorCrtl = TextEditingController();
  TextEditingController nome_portadorCrtl = TextEditingController();
  bool isLoading = false;
  bool codigoConfirmadoApi = false;
  String mensagemApi = '';

  Future<bool> comparaCodigoEntrega(BuildContext context, idunidade,
      {required String? protocoloRetirada,
      required String? tipoCompara,
      required String? nome_portador,
      required String? documento_portador,
      String? listEntregar,
      String? senha}) async {
    tipoCompara ?? senha;
    String senhaCripto;
    if (tipoCompara == 'senha') {
      senhaCripto = md5.convert(utf8.encode(senha!)).toString();
    } else {
      senhaCripto = '';
    }

    var url = Uri.parse(tipoCompara == 'codigo'
        //tipoCompara 1 CÓDIGO
        ? '${Consts.apiPortaria}correspondencias/?fn=compararProtocolos&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade&protocolo=$protocoloRetirada&protocoloentrega=${codigoConfirCrtl.text}&nome_portador=$nome_portador&documento_portador=$documento_portador'
        //tipoCompara 2 SENHA
        : '${Consts.apiPortaria}correspondencias/?fn=compararSenhaRetirada&idcond=${FuncionarioInfos.idcondominio}&idmorador=${widget.idMorador}&listacorrespondencias=$listEntregar&senha_retirada=$senhaCripto');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      var jsons = json.decode(resposta.body);
      mensagemApi = jsons['mensagem'];
      return codigoConfirmadoApi = jsons['erro'];
    } else {
      return false;
    }
  }

  loadingConfirmacao() {
    setState(() {
      isLoading = true;
      codigoConfirmadoApi = false;
    });
    // comparaCodigoEntrega(widget.idunidade, protocoloRetirada: confirmacao);

    comparaCodigoEntrega(context, widget.idunidade,
            protocoloRetirada: widget.protocoloRetirada,
            tipoCompara: widget.tipoCompara,
            senha: codigoConfirCrtl.text,
            documento_portador: documento_portadorCrtl.text,
            nome_portador: nome_portadorCrtl.text,
            listEntregar: widget.listEntregar)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (!codigoConfirmadoApi) {
        buildMinhaSnackBar(
          context,
          title: 'Tudo Certo',
          subTitle: mensagemApi,
        );
        ConstsFuture.navigatorPushRemoveUntil(context, HomePage());
      } else if (codigoConfirmadoApi) {
        buildMinhaSnackBar(context,
            hasError: true, title: 'Algo Errado', subTitle: mensagemApi);
        setState(() {
          codigoConfirmadoApi == true;
        });
      }
    });
  }

  bool isChecked = false;

  @override
  void initState() {
    isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ScaffoldAll(
        title: 'Emitir entrega',
        body: ConstsWidget.buildPadding001(
          context,
          horizontal: 0.02,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ConstsWidget.buildClosePop(context, title: 'Confirmar entrega'),
                // if (widget.tipoCompara == 2)
                // buildFuture(),
                // ConstsWidget.buildMyTextFormObrigatorio(
                //   context,
                //   'Código de confirmação',
                //   mensagem: 'Peça o código de entrega',
                //   obscureText: true,
                //   onSaved: (text) {
                //     confirmacao = text;
                //   },
                // ),

                TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: codigoConfirCrtl,

                  // autofillHints: [AutofillHints.password],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha é obrigatório'),
                    Validatorless.min(3, 'Mínimo de 6 caracteres')
                  ]),
                  onEditingComplete: () => TextInput.finishAutofillContext(),
                  autofillHints: const [AutofillHints.password],
                  obscureText: obscure,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.045,
                        vertical: size.height * 0.025),
                    filled: true,
                    fillColor: Theme.of(context).canvasColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    label: Text(
                      widget.idMorador != null
                          ? 'Senha Retirada'
                          : 'Código de confirmação',
                    ),
                    hintText: widget.idMorador != null
                        ? 'Senha Retirada'
                        : 'Código de confirmação',
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                ConstsWidget.buildPadding001(
                  context,
                  vertical: 0.02,
                  child: ConstsWidget.buildTitleText(
                    context,
                    title: widget.idMorador != null
                        ? 'Peça a Senha Retirada'
                        : 'Peça o código de entrega',
                    color: Colors.red,
                  ),
                ),
                if (widget.idMorador == null)
                  Column(
                    children: [
                      ConstsWidget.buildPadding001(
                        context,
                        child: buildMyTextFormObrigatorio(
                            context, 'Nome Portador',
                            controller: nome_portadorCrtl),
                      ),
                      ConstsWidget.buildPadding001(context,
                          child: buildMyTextFormObrigatorio(
                              context, 'Documento',
                              controller: documento_portadorCrtl,
                              keyboardType: TextInputType.number)),
                    ],
                  ),

                ConstsWidget.buildLoadingButton(context, onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    loadingConfirmacao();
                  }
                }, isLoading: isLoading, title: 'Confirmar Entrega'),
              ],
            ),
          ),
        ));
  }
}
