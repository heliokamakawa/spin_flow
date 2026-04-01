import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';
import 'package:spin_flow/validacoes/validador_url.dart';

class CampoUrl extends StatelessWidget {
  final TextEditingController? controle;
  final String? valorInicial;
  final String rotulo;
  final String dica;
  final String mensagemErro;
  final bool eObrigatorio;
  final String? Function(String?)? validador;
  final void Function(String)? aoAlterar;
  final Widget? prefixoIcone;

  const CampoUrl({
    super.key,
    this.controle,
    this.valorInicial,
    this.rotulo = 'Link',
    this.dica = 'https://site.com',
    this.mensagemErro = Erro.urlInvalido,
    this.eObrigatorio = false,
    this.validador,
    this.aoAlterar,
    this.prefixoIcone,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _definirController(),
      initialValue: valorInicial,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
        prefixIcon: prefixoIcone ?? const Icon(Icons.link),
      ),
      validator: (valor) => _validarCampo(valor),
      onChanged: aoAlterar,
      autofillHints: const [AutofillHints.url],
    );
  }

  TextEditingController? _definirController() {
    return valorInicial != null ? null : controle;
  }

  String? _validarCampo(String? valor) {
    if (validador != null) {
      return validador!(valor);
    }
    if ((valor == null || valor.isEmpty)) {
      return eObrigatorio ? Erro.obrigatorio : null;
    }
    final erroUrl = ValidadorUrl.validarUrl(valor);
    if (erroUrl != null) return mensagemErro;
    return null;
  }
}

